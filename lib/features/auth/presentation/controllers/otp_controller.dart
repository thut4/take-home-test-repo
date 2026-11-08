import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/auth_providers.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';
import 'package:jdonuts/features/auth/domain/validators/otp_validator.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';

part 'otp_controller.freezed.dart';

// Message under the OTP boxes.
enum OtpFeedback { wrong, locked, resent, network, generic }

@freezed
abstract class OtpState with _$OtpState {
  const factory OtpState({
    required DateTime sentAt,
    required DateTime now,
    @Default(0) int failedAttempts,
    @Default(false) bool isVerifying,
    @Default(false) bool isResending,
    OtpFeedback? feedback,
  }) = _OtpState;

  const OtpState._();

  Duration get resendIn => otpResendRemaining(sentAt: sentAt, now: now);
  bool get canResend => resendIn == Duration.zero && !isResending;
  bool get isLocked => failedAttempts >= OtpPolicy.maxAttempts;
  int get attemptsLeft => OtpPolicy.maxAttempts - failedAttempts;
}

// What the screen should do after a verification attempt.
enum OtpOutcome {
  // Busy or locked; nothing happened.
  ignored,

  // Wrong code: shake and clear the boxes.
  wrong,

  // Couldn't check the code (offline, storage error).
  failed,

  // Register path: continue to Name.
  verified,

  // Log-in path: signed in; the router moves to Home.
  signedIn,
}

final NotifierProvider<OtpController, OtpState> otpControllerProvider =
    NotifierProvider.autoDispose<OtpController, OtpState>(OtpController.new);

class OtpController extends Notifier<OtpState> {
  static const _tick = Duration(seconds: 1);

  @override
  OtpState build() {
    final clock = ref.watch(clockProvider);
    final sentAt = ref.read(authFlowControllerProvider).otpSentAt ?? clock();
    final timer = Timer.periodic(_tick, (_) {
      if (ref.mounted) state = state.copyWith(now: clock());
    });
    ref.onDispose(timer.cancel);
    return OtpState(sentAt: sentAt, now: clock());
  }

  Future<OtpOutcome> verify(String code) async {
    if (state.isLocked || state.isVerifying) return OtpOutcome.ignored;
    state = state.copyWith(isVerifying: true, feedback: null);
    final flow = ref.read(authFlowControllerProvider);
    final result = await ref.read(verifyOtpProvider)(
      phone: flow.phone ?? '',
      code: code,
      mode: flow.mode,
    );
    if (!ref.mounted) return OtpOutcome.ignored;
    state = state.copyWith(isVerifying: false);
    return switch (result) {
      Ok(value: final UserAccount account) => _signedIn(account),
      Ok() => OtpOutcome.verified,
      Err(failure: WrongOtpFailure()) => _wrongCode(),
      Err() => _failed(),
    };
  }

  // Sends a new code, restarts the countdown and unlocks entry.
  Future<void> resend() async {
    if (!state.canResend) return;
    state = state.copyWith(isResending: true);
    final phone = ref.read(authFlowControllerProvider).phone ?? '';
    final result = await ref.read(resendOtpProvider)(phone);
    if (!ref.mounted) return;
    final now = ref.read(clockProvider)();
    state = switch (result) {
      Ok() => OtpState(sentAt: now, now: now, feedback: OtpFeedback.resent),
      Err() => state.copyWith(
        isResending: false,
        feedback: OtpFeedback.network,
      ),
    };
  }

  OtpOutcome _signedIn(UserAccount account) {
    ref.read(sessionControllerProvider.notifier).signIn(account);
    return OtpOutcome.signedIn;
  }

  OtpOutcome _wrongCode() {
    final attempts = state.failedAttempts + 1;
    state = state.copyWith(
      failedAttempts: attempts,
      feedback: attempts >= OtpPolicy.maxAttempts
          ? OtpFeedback.locked
          : OtpFeedback.wrong,
    );
    return OtpOutcome.wrong;
  }

  OtpOutcome _failed() {
    state = state.copyWith(feedback: OtpFeedback.network);
    return OtpOutcome.failed;
  }
}
