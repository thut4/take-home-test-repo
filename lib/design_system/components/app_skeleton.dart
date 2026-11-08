import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/tokens/color_tokens.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';

/// Sweeps a highlight across every [AppSkeletonBox] below it. One shimmer
/// per section keeps all boxes in phase. Static under Reduce Motion.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) =>
              _gradient(_controller.value).createShader(bounds),
          child: child,
        ),
      ),
    );
  }

  static LinearGradient _gradient(double t) {
    final centre = -1 + 3 * t;
    return LinearGradient(
      begin: Alignment(centre - 1, -0.3),
      end: Alignment(centre + 1, 0.3),
      colors: const [
        AppArtColors.skeletonBase,
        AppArtColors.skeletonShine,
        AppArtColors.skeletonBase,
      ],
      stops: const [0.35, 0.5, 0.65],
    );
  }
}

/// Grey placeholder block, shaped like the content that will replace it.
class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.md,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppArtColors.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
