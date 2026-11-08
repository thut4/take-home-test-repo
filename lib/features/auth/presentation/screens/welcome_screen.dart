import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';
import 'package:jdonuts/features/auth/presentation/widgets/auth_step_scaffold.dart';
import 'package:jdonuts/features/auth/presentation/widgets/donut_art.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Screen 7, after registration: donut tiles slide in one by one, then the
// title fades up.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  static const _tileCount = 4;

  void _explore(BuildContext context, WidgetRef ref) {
    ref.read(sessionControllerProvider.notifier).welcomeSeen();
    context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
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
                _TileGrid(width: constraints.maxWidth),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenGutter),
                    child: AppEntrance(
                      index: _tileCount + 2,
                      child: Column(
                        children: [
                          Text(
                            l10n.welcomeTitle,
                            style: context.appTheme.text.display,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          AppCtaButton(
                            key: const Key('lets-explore'),
                            label: l10n.letsExplore,
                            onPressed: () => _explore(context, ref),
                          ),
                        ],
                      ),
                    ),
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

// Two staggered columns of rounded tiles that bleed off the edges.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.width});

  final double width;

  static const _heightRatio = 1.12;

  @override
  Widget build(BuildContext context) {
    final w = width;
    return SizedBox(
      height: w * _heightRatio,
      child: Stack(
        children: [
          _tile(
            w,
            -0.08,
            -0.06,
            0,
            AppArtColors.tileBlue,
            AppAsset.donutBlueberry,
            const Offset(-80, 0),
          ),
          _tile(
            w,
            0.56,
            0.04,
            1,
            AppArtColors.tilePink,
            AppAsset.donutStrawberryChoc,
            const Offset(80, 0),
          ),
          _tile(
            w,
            -0.08,
            0.58,
            2,
            AppArtColors.tilePeach,
            AppAsset.donutPinkSprinkle,
            const Offset(-80, 40),
          ),
          _tile(
            w,
            0.56,
            0.68,
            3,
            AppArtColors.tileYellow,
            AppAsset.donutChocSprinkle,
            const Offset(80, 40),
          ),
        ],
      ),
    );
  }

  Widget _tile(
    double w,
    double left,
    double top,
    int index,
    Color colour,
    String donut,
    Offset from,
  ) {
    final size = w * 0.52;
    return Positioned(
      left: w * left,
      top: w * top,
      child: AppEntrance(
        index: index,
        offset: from,
        duration: AppMotion.slower,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colour,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: CustomPaint(
            painter: SprinklePainter(
              seed: index + 3,
              count: 7,
              colors: AppArtColors.sprinkles,
            ),
            child: Center(
              child: Image.asset(
                donut,
                width: size * 0.78,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
