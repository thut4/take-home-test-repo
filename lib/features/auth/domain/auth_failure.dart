import 'package:jdonuts/core/failure.dart';

// Failures specific to signing in and registering.
sealed class AuthFailure extends Failure {
  const AuthFailure();
}

// Log in was attempted with a number that never registered.
final class PhoneNotRegisteredFailure extends AuthFailure {
  const PhoneNotRegisteredFailure();

  @override
  String get debugMessage => 'Phone not registered';
}

// Registration was attempted with a number that already has an account.
final class PhoneAlreadyRegisteredFailure extends AuthFailure {
  const PhoneAlreadyRegisteredFailure();

  @override
  String get debugMessage => 'Phone already registered';
}

// The one-time code didn't match.
final class WrongOtpFailure extends AuthFailure {
  const WrongOtpFailure();

  @override
  String get debugMessage => 'Wrong OTP';
}

// A step that needs a verified number ran before OTP verification.
final class OtpNotVerifiedFailure extends AuthFailure {
  const OtpNotVerifiedFailure();

  @override
  String get debugMessage => 'OTP not verified';
}

// Input reached a use case without passing its validator.
final class InvalidInputFailure extends AuthFailure {
  const InvalidInputFailure(this.field);

  final String field;

  @override
  String get debugMessage => 'Invalid $field';
}
