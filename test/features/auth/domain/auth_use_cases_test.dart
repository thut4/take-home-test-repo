import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/auth_repository.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';

/// Hand-written fake: records calls, answers from fields.
class FakeAuthRepository implements AuthRepository {
  bool registered = false;
  Result<Unit> verifyResult = const Ok(unit);
  final sentTo = <String>[];
  UserAccount? registeredAccount;

  @override
  Future<Result<bool>> isRegistered(String phone) async => Ok(registered);

  @override
  Future<Result<Unit>> sendOtp(String phone) async {
    sentTo.add(phone);
    return const Ok(unit);
  }

  @override
  Future<Result<Unit>> verifyOtp({
    required String phone,
    required String code,
  }) async => verifyResult;

  @override
  Future<Result<UserAccount>> register(UserAccount account) async {
    registeredAccount = account;
    return Ok(account);
  }

  @override
  Future<Result<UserAccount>> logIn(String phone) async => Ok(
    UserAccount(phone: phone, firstName: 'Hania', dateOfBirth: DateTime(1995)),
  );

  @override
  Future<Result<UserAccount?>> restoreSession() async => const Ok(null);

  @override
  Future<Result<Unit>> logOut() async => const Ok(unit);
}

void main() {
  late FakeAuthRepository repository;

  setUp(() => repository = FakeAuthRepository());

  group('RequestOtp', () {
    test('sends the code to the normalised number on register', () async {
      final result = await RequestOtp(repository)(
        '09 254 135 592',
        AuthMode.register,
      );
      expect(result, const Ok('+959254135592'));
      expect(repository.sentTo, ['+959254135592']);
    });

    test('refuses log in for a number that never registered', () async {
      final result = await RequestOtp(repository)(
        '09254135592',
        AuthMode.logIn,
      );
      expect(result.failureOrNull, isA<PhoneNotRegisteredFailure>());
      expect(repository.sentTo, isEmpty);
    });

    test(
      'refuses registration for a number that already has an account',
      () async {
        repository.registered = true;
        final result = await RequestOtp(repository)(
          '09254135592',
          AuthMode.register,
        );
        expect(result.failureOrNull, isA<PhoneAlreadyRegisteredFailure>());
      },
    );

    test('rejects an invalid number without calling the back end', () async {
      final result = await RequestOtp(repository)('123', AuthMode.register);
      expect(result.failureOrNull, isA<InvalidInputFailure>());
      expect(repository.sentTo, isEmpty);
    });
  });

  group('VerifyOtp', () {
    test('rejects an incomplete code before calling the back end', () async {
      repository.verifyResult = const Err(UnexpectedFailure('not called'));
      final result = await VerifyOtp(repository)(
        phone: '+959254135592',
        code: '123',
        mode: AuthMode.register,
      );
      expect(result.failureOrNull, isA<WrongOtpFailure>());
    });

    test('returns no account on the register path', () async {
      final result = await VerifyOtp(repository)(
        phone: '+959254135592',
        code: '123456',
        mode: AuthMode.register,
      );
      expect(result, const Ok<UserAccount?>(null));
    });

    test('signs in on the log-in path', () async {
      final result = await VerifyOtp(repository)(
        phone: '+959254135592',
        code: '123456',
        mode: AuthMode.logIn,
      );
      expect(result.valueOrNull?.firstName, 'Hania');
    });

    test('passes a wrong-code failure through', () async {
      repository.verifyResult = const Err(WrongOtpFailure());
      final result = await VerifyOtp(repository)(
        phone: '+959254135592',
        code: '000000',
        mode: AuthMode.logIn,
      );
      expect(result.failureOrNull, isA<WrongOtpFailure>());
    });
  });

  group('CompleteRegistration', () {
    final today = DateTime(2026, 11, 8);

    Future<Result<UserAccount>> complete({
      String first = ' Ye Min ',
      String last = '  ',
      int? year = 1980,
    }) => CompleteRegistration(repository, () => today)(
      phone: '+959254135592',
      firstName: first,
      lastName: last,
      year: year,
      month: 5,
      day: 1,
    );

    test('trims names and stores an empty last name as null', () async {
      await complete();
      expect(repository.registeredAccount?.firstName, 'Ye Min');
      expect(repository.registeredAccount?.lastName, isNull);
      expect(repository.registeredAccount?.dateOfBirth, DateTime(1980, 5));
    });

    test('re-checks the name rules', () async {
      final result = await complete(first: 'R2D2');
      expect(result.failureOrNull, isA<InvalidInputFailure>());
      expect(repository.registeredAccount, isNull);
    });

    test('re-checks the minimum age', () async {
      final result = await complete(year: 2020);
      expect(result.failureOrNull, isA<InvalidInputFailure>());
    });
  });
}
