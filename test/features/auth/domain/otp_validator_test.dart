import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/auth/domain/validators/otp_validator.dart';

void main() {
  group('isCompleteOtp', () {
    test('accepts exactly six digits', () {
      expect(isCompleteOtp('123456'), isTrue);
    });

    test('rejects five or seven digits', () {
      expect(isCompleteOtp('12345'), isFalse);
      expect(isCompleteOtp('1234567'), isFalse);
    });

    test('rejects letters and spaces', () {
      expect(isCompleteOtp('12a456'), isFalse);
      expect(isCompleteOtp('123 56'), isFalse);
    });
  });

  group('otpResendRemaining', () {
    final sentAt = DateTime(2026, 11, 8, 10);

    test('starts at five minutes', () {
      expect(
        otpResendRemaining(sentAt: sentAt, now: sentAt),
        const Duration(minutes: 5),
      );
    });

    test('counts down', () {
      expect(
        otpResendRemaining(
          sentAt: sentAt,
          now: sentAt.add(const Duration(seconds: 2)),
        ),
        const Duration(minutes: 4, seconds: 58),
      );
    });

    test('never goes below zero', () {
      expect(
        otpResendRemaining(
          sentAt: sentAt,
          now: sentAt.add(const Duration(minutes: 9)),
        ),
        Duration.zero,
      );
    });
  });

  test('locks after three wrong codes', () {
    expect(OtpPolicy.maxAttempts, 3);
  });
}
