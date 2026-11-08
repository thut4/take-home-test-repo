import 'package:jdonuts/core/clock.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/auth_repository.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';
import 'package:jdonuts/features/auth/domain/validators/date_of_birth_validator.dart';
import 'package:jdonuts/features/auth/domain/validators/name_validator.dart';
import 'package:jdonuts/features/auth/domain/validators/otp_validator.dart';
import 'package:jdonuts/features/auth/domain/validators/phone_validator.dart';

// Which path the user is on.
enum AuthMode { register, logIn }

// Phone step: checks the number fits the [AuthMode] and sends a code.
// Returns the E.164 number the code went to.
class RequestOtp {
  const RequestOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call(String rawPhone, AuthMode mode) async {
    final phone = normalizeMyanmarPhone(rawPhone);
    if (phone == null) return const Err(InvalidInputFailure('phone'));
    final registered = await _repository.isRegistered(phone);
    switch (registered) {
      case Err(:final failure):
        return Err(failure);
      case Ok(value: false) when mode == AuthMode.logIn:
        return const Err(PhoneNotRegisteredFailure());
      case Ok(value: true) when mode == AuthMode.register:
        return const Err(PhoneAlreadyRegisteredFailure());
      case Ok():
        final sent = await _repository.sendOtp(phone);
        return sent.map((_) => phone);
    }
  }
}

// Resend: a fresh code to the same number.
class ResendOtp {
  const ResendOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<Unit>> call(String phone) => _repository.sendOtp(phone);
}

// OTP step. On the log-in path a correct code also signs the user in.
// Returns the account on log in, null on the register path.
class VerifyOtp {
  const VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<UserAccount?>> call({
    required String phone,
    required String code,
    required AuthMode mode,
  }) async {
    if (!isCompleteOtp(code)) return const Err(WrongOtpFailure());
    final verified = await _repository.verifyOtp(phone: phone, code: code);
    if (verified case Err(:final failure)) return Err(failure);
    if (mode == AuthMode.register) return const Ok(null);
    return await _repository.logIn(phone);
  }
}

// Last registration step. Re-validates everything, so the rules hold even
// if a screen is bypassed, then creates the account.
class CompleteRegistration {
  const CompleteRegistration(this._repository, this._clock);

  final AuthRepository _repository;
  final Clock _clock;

  Future<Result<UserAccount>> call({
    required String phone,
    required String firstName,
    required String lastName,
    required int? year,
    required int? month,
    required int? day,
  }) async {
    if (validateFirstName(firstName) != null) {
      return const Err(InvalidInputFailure('firstName'));
    }
    if (validateLastName(lastName) != null) {
      return const Err(InvalidInputFailure('lastName'));
    }
    final dobError = validateDateOfBirth(
      year: year,
      month: month,
      day: day,
      today: _clock(),
    );
    if (dobError != null) return const Err(InvalidInputFailure('dob'));
    final trimmedLast = lastName.trim();
    return await _repository.register(
      UserAccount(
        phone: phone,
        firstName: firstName.trim(),
        lastName: trimmedLast.isEmpty ? null : trimmedLast,
        dateOfBirth: DateTime(year!, month!, day!),
      ),
    );
  }
}

class RestoreSession {
  const RestoreSession(this._repository);

  final AuthRepository _repository;

  Future<Result<UserAccount?>> call() => _repository.restoreSession();
}

class LogOut {
  const LogOut(this._repository);

  final AuthRepository _repository;

  Future<Result<Unit>> call() => _repository.logOut();
}
