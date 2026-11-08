/// One-time password rules.
abstract final class OtpPolicy {
  static const codeLength = 6;

  /// Wrong codes allowed before entry locks until a new code is sent.
  static const maxAttempts = 3;

  /// Time before the user can ask for a new code.
  static const resendCooldown = Duration(minutes: 5);
}

final _otpPattern = RegExp('^\\d{${OtpPolicy.codeLength}}\$');

/// True when [code] is exactly [OtpPolicy.codeLength] ASCII digits.
bool isCompleteOtp(String code) => _otpPattern.hasMatch(code);

/// Time left before Resend unlocks, never negative.
Duration otpResendRemaining({required DateTime sentAt, required DateTime now}) {
  final remaining = sentAt.add(OtpPolicy.resendCooldown).difference(now);
  return remaining.isNegative ? Duration.zero : remaining;
}
