import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/widgets/legal_footer.dart';
import 'package:jdonuts/features/auth/presentation/widgets/step_progress_ring.dart';

// Shared frame of the phone, OTP, name and date-of-birth steps: back
// button, progress ring, title, content, Continue and the legal footer.
// Scrolls when the keyboard or a large text scale needs the room.
class AuthStepScaffold extends StatelessWidget {
  const AuthStepScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.children,
    this.subtitle,
    this.step,
    this.continueLabel,
    this.onContinue,
    this.isLoading = false,
  });

  final String title;
  final Widget? subtitle;
  final VoidCallback onBack;
  final List<Widget> children;

  // 1-based step for the progress ring; null hides the ring (log-in path).
  final int? step;

  // Null hides the Continue button (the OTP step submits on its own).
  final String? continueLabel;
  final VoidCallback? onContinue;
  final bool isLoading;

  // Keeps the ring still while pages slide between steps.
  static const ringHeroTag = 'registration-step-ring';

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      // Blush, so the area behind the keyboard matches the wash.
      backgroundColor: context.appTheme.colors.backgroundBlush,
      background: const AuthBackground(),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenGutter,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: _content(context),
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final text = context.appTheme.text;
    final continueLabel = this.continueLabel;
    final subtitle = this.subtitle;
    // spaceBetween inside a min-height box pins the footer to the bottom
    // on tall screens and lets everything scroll on short ones.
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.md),
            _TopBar(onBack: onBack, step: step),
            const SizedBox(height: AppSpacing.xl),
            Text(title, style: text.headline),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              subtitle,
            ],
            const SizedBox(height: AppSpacing.xl),
            ...children,
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            if (continueLabel != null)
              AppCtaButton(
                label: continueLabel,
                onPressed: onContinue,
                isLoading: isLoading,
              ),
            const SizedBox(height: AppSpacing.xl),
            const LegalFooter(),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack, required this.step});

  final VoidCallback onBack;
  final int? step;

  @override
  Widget build(BuildContext context) {
    final step = this.step;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBackButton(onPressed: onBack),
        if (step != null)
          Hero(
            tag: AuthStepScaffold.ringHeroTag,
            child: StepProgressRing(key: ValueKey(step), step: step),
          ),
      ],
    );
  }
}

// Soft pink wash behind onboarding and registration.
class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.backgroundBlush,
            colors.background,
            colors.backgroundBlush,
          ],
          stops: const [0, 0.6, 1],
        ),
      ),
    );
  }
}
