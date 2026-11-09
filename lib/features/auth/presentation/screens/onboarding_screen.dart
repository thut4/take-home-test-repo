import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/features/auth/presentation/widgets/donut_art.dart';
import 'package:jdonuts/features/auth/presentation/widgets/legal_footer.dart';
import 'package:jdonuts/features/auth/presentation/widgets/social_sign_in_row.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Screen 1: donut circles drift in, then the title and buttons enter one
// after another.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  void _start(BuildContext context, WidgetRef ref, AuthMode mode) {
    ref.read(authFlowControllerProvider.notifier).start(mode);
    unawaited(context.push(Routes.phone));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveScaffold(
      // Blush, so the area behind the keyboard matches the wash.
      backgroundColor: context.appTheme.colors.backgroundBlush,
      background: const AuthBackground(),
      safeArea: false,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _CircleCollage(width: constraints.maxWidth),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenGutter,
                      ),
                      child: _Actions(
                        onStart: (mode) => _start(context, ref, mode),
                      ),
                    ),
                  ],
                ),
                const SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenGutter,
                      AppSpacing.xl,
                      AppSpacing.screenGutter,
                      AppSpacing.lg,
                    ),
                    child: AppEntrance(index: 8, child: LegalFooter()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Title, Let's get started, Log in and the social buttons, entering one
// after another once the circles have drifted in.
class _Actions extends StatelessWidget {
  const _Actions({required this.onStart});

  final ValueChanged<AuthMode> onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        AppEntrance(
          index: 4,
          child: Text(
            l10n.onboardingTitle,
            style: context.appTheme.text.display,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppEntrance(
          index: 5,
          child: AppCtaButton(
            key: const Key('get-started'),
            label: l10n.getStarted,
            onPressed: () => onStart(AuthMode.register),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppEntrance(
          index: 6,
          child: _LogInPrompt(onLogIn: () => onStart(AuthMode.logIn)),
        ),
        const SizedBox(height: AppSpacing.md),
        const AppEntrance(index: 7, child: SocialSignInRow()),
      ],
    );
  }
}

// The donut circles at the top, laid out relative to the screen width so
// they crop at the edges the way the design does.
class _CircleCollage extends StatelessWidget {
  const _CircleCollage({required this.width});

  final double width;

  static const _heightRatio = 0.95;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final colors = context.appTheme.colors;
    return SizedBox(
      height: w * _heightRatio,
      child: Stack(
        children: [
          _circle(w, -0.22, -0.12, 0.48, const Offset(-60, -40), 0, const [
            AppArtColors.tileCyan,
            AppArtColors.tileBlue,
          ], AppAsset.donutBlueberry),
          _circle(w, 0.82, -0.08, 0.36, const Offset(60, -40), 1, const [
            AppArtColors.tilePink,
            AppArtColors.tilePeach,
          ], AppAsset.donutStrawberryChoc),
          _circle(w, 0.84, 0.38, 0.42, const Offset(70, 0), 2, const [
            AppArtColors.tileBlue,
            AppArtColors.tileBlue,
          ], AppAsset.donutBlueberry),
          _circle(w, 0.3, 0.68, 0.42, const Offset(0, 60), 3, const [
            AppArtColors.tileYellow,
            AppArtColors.tilePeach,
          ], AppAsset.donutChocSprinkle),
          _circle(
            w,
            0.22,
            0.12,
            0.56,
            const Offset(0, -30),
            1,
            [AppArtColors.tilePeach, colors.backgroundBlush],
            AppAsset.donutPinkSprinkle,
            seed: 7,
          ),
          Positioned.fill(child: _FadeOut(color: colors.backgroundBlush)),
        ],
      ),
    );
  }

  Widget _circle(
    double w,
    double left,
    double top,
    double diameter,
    Offset from,
    int index,
    List<Color> fill,
    String donut, {
    int? seed,
  }) {
    return Positioned(
      left: w * left,
      top: w * top,
      child: AppEntrance(
        index: index,
        offset: from,
        duration: AppMotion.drift,
        child: IdleFloat(
          phase: index * 0.23,
          child: DonutCircle(
            diameter: w * diameter,
            colors: fill,
            donutAsset: donut,
            sprinkleSeed: seed,
          ),
        ),
      ),
    );
  }
}

class _FadeOut extends StatelessWidget {
  const _FadeOut({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0), color],
            stops: const [0.7, 1],
          ),
        ),
      ),
    );
  }
}

class _LogInPrompt extends StatefulWidget {
  const _LogInPrompt({required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  State<_LogInPrompt> createState() => _LogInPromptState();
}

class _LogInPromptState extends State<_LogInPrompt> {
  final _tap = TapGestureRecognizer();

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.appTheme;
    _tap.onTap = widget.onLogIn;
    return Text.rich(
      key: const Key('log-in-link'),
      TextSpan(
        style: theme.text.caption.copyWith(color: theme.colors.onSurface),
        children: [
          TextSpan(text: '${l10n.haveAccount} '),
          TextSpan(
            text: l10n.logIn,
            recognizer: _tap,
            style: TextStyle(
              fontSize: theme.text.subtitle.fontSize,
              color: theme.colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
