import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/auth_providers.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';

part 'auth_flow_controller.freezed.dart';

// Everything entered across the registration / log-in steps. Kept for the
// whole flow, so Back returns to a step with its values intact.
@freezed
abstract class AuthFlowState with _$AuthFlowState {
  const factory AuthFlowState({
    required AuthMode mode,
    @Default('') String phoneInput,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default(false) bool isSubmitting,
    String? phone,
    DateTime? otpSentAt,
    int? month,
    int? day,
    int? year,
  }) = _AuthFlowState;
}

// Result of pressing Continue.
sealed class StepOutcome {
  const StepOutcome();
}

final class StepDone extends StepOutcome {
  const StepDone();
}

final class StepFailed extends StepOutcome {
  const StepFailed(this.failure);

  final Failure failure;
}

// A second tap while the first request is still running.
final class StepIgnored extends StepOutcome {
  const StepIgnored();
}

final authFlowControllerProvider =
    NotifierProvider<AuthFlowController, AuthFlowState>(AuthFlowController.new);

class AuthFlowController extends Notifier<AuthFlowState> {
  @override
  AuthFlowState build() => const AuthFlowState(mode: AuthMode.register);

  // Starts a fresh flow from Onboarding.
  void start(AuthMode mode) => state = AuthFlowState(mode: mode);

  // "Create an account" / "Log in instead" on the phone step.
  void switchMode(AuthMode mode) => state = state.copyWith(mode: mode);

  void setPhoneInput(String value) => state = state.copyWith(phoneInput: value);

  void setNames({required String firstName, required String lastName}) =>
      state = state.copyWith(firstName: firstName, lastName: lastName);

  void setDateOfBirth({int? month, int? day, int? year}) =>
      state = state.copyWith(month: month, day: day, year: year);

  // Phone step: checks the number and sends the code.
  Future<StepOutcome> submitPhone() => _guarded(() async {
    final result = await ref.read(requestOtpProvider)(
      state.phoneInput,
      state.mode,
    );
    if (result case Ok(value: final phone) when ref.mounted) {
      state = state.copyWith(
        phone: phone,
        otpSentAt: ref.read(clockProvider)(),
      );
    }
    return result;
  });

  // Last registration step: creates the account and signs it in. The
  // router then moves to Welcome.
  Future<StepOutcome> submitDateOfBirth() => _guarded(() async {
    final result = await ref.read(completeRegistrationProvider)(
      phone: state.phone ?? '',
      firstName: state.firstName,
      lastName: state.lastName,
      year: state.year,
      month: state.month,
      day: state.day,
    );
    if (result case Ok(value: final account) when ref.mounted) {
      ref
          .read(sessionControllerProvider.notifier)
          .signIn(account, isNewAccount: true);
    }
    return result;
  });

  // Runs [body] once at a time: taps while it runs are ignored, which is
  // how a double tap sends a single request.
  Future<StepOutcome> _guarded<T>(Future<Result<T>> Function() body) async {
    if (state.isSubmitting) return const StepIgnored();
    state = state.copyWith(isSubmitting: true);
    final result = await body();
    if (!ref.mounted) return const StepIgnored();
    state = state.copyWith(isSubmitting: false);
    return switch (result) {
      Ok() => const StepDone(),
      Err(:final failure) => StepFailed(failure),
    };
  }
}
