import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/controllers/otp_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Step 2: the one-time code. Submits by itself once six digits are in;
// a wrong code shakes and clears the boxes, three lock entry until Resend.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controller = TextEditingController();
  int _shakes = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    final outcome = await ref.read(otpControllerProvider.notifier).verify(code);
    if (!mounted) return;
    switch (outcome) {
      case OtpOutcome.wrong:
        setState(() => _shakes++);
        _controller.clear();
      case OtpOutcome.verified:
        await context.push(Routes.name);
      case OtpOutcome.failed:
        _controller.clear();
      case OtpOutcome.signedIn || OtpOutcome.ignored:
        break;
    }
  }

  Future<void> _resend() async {
    _controller.clear();
    await ref.read(otpControllerProvider.notifier).resend();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final flow = ref.watch(authFlowControllerProvider);
    final otp = ref.watch(otpControllerProvider);
    final theme = context.appTheme;
    return AuthStepScaffold(
      title: l10n.otpTitle,
      subtitle: Text(
        l10n.otpSubtitle(flow.phone ?? ''),
        style: theme.text.caption.copyWith(color: theme.colors.onSurface),
      ),
      step: flow.mode == AuthMode.register ? 2 : null,
      onBack: () => context.pop(),
      children: [
        AppCodeInput(
          key: const Key('otp-input'),
          controller: _controller,
          semanticLabel: l10n.otpFieldLabel,
          enabled: !otp.isLocked && !otp.isVerifying,
          hasError:
              otp.feedback == OtpFeedback.wrong ||
              otp.feedback == OtpFeedback.locked,
          shakeCount: _shakes,
          onCompleted: _verify,
        ),
        const SizedBox(height: AppSpacing.md),
        _Feedback(state: otp),
        const SizedBox(height: AppSpacing.lg),
        _ResendRow(state: otp, onResend: _resend),
      ],
    );
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.state});

  final OtpState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.appTheme;
    final feedback = state.feedback;
    final message = switch (feedback) {
      OtpFeedback.wrong => l10n.otpWrong(state.attemptsLeft),
      OtpFeedback.locked => l10n.otpLocked,
      OtpFeedback.resent => l10n.otpResent,
      OtpFeedback.network => l10n.networkError,
      OtpFeedback.generic => l10n.genericError,
      null => null,
    };
    final isError = feedback != OtpFeedback.resent;
    return AnimatedSwitcher(
      duration: context.motion(AppMotion.fast),
      child: state.isVerifying
          ? const Center(child: AdaptiveLoadingIndicator())
          : message == null
          ? const SizedBox.shrink()
          : Semantics(
              liveRegion: true,
              child: Text(
                message,
                key: ValueKey(message),
                style: theme.text.caption.copyWith(
                  color: isError ? theme.colors.error : theme.colors.success,
                ),
              ),
            ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.state, required this.onResend});

  final OtpState state;
  final VoidCallback onResend;

  static String _clock(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.appTheme;
    final dark = theme.text.caption.copyWith(color: theme.colors.onSurface);
    final accent = dark.copyWith(color: theme.colors.accent);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.otpNoCode, style: dark),
        if (state.resendIn > Duration.zero)
          Text.rich(
            TextSpan(
              style: dark,
              children: [
                TextSpan(text: l10n.otpResendIn),
                TextSpan(text: _clock(state.resendIn), style: accent),
                TextSpan(text: l10n.minutesShort),
              ],
            ),
          )
        else
          AppPressable(
            key: const Key('otp-resend'),
            onPressed: state.isResending ? null : onResend,
            semanticLabel: l10n.otpResend,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l10n.otpResend,
                style: accent.copyWith(
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
