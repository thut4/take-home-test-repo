import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:jdonuts/design_system/tokens/motion_tokens.dart';

/// Reduce Motion support. Every animation reads its duration through
/// [motion], which returns [Duration.zero] when the platform asks for
/// animations to be disabled (`MediaQuery.disableAnimations`).
extension AppMotionContext on BuildContext {
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}

/// Fades and slides [child] up into place, [index] steps after the screen
/// appears. Under Reduce Motion it shows immediately.
class AppEntrance extends StatefulWidget {
  const AppEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = Duration.zero,
    this.offset = const Offset(0, AppMotion.entranceOffset),
    this.duration = AppMotion.entrance,
  });

  final Widget child;
  final int index;

  /// Extra delay before the stagger starts.
  final Duration delay;

  /// Where the child starts, relative to its resting place.
  final Offset offset;
  final Duration duration;

  @override
  State<AppEntrance> createState() => _AppEntranceState();
}

class _AppEntranceState extends State<AppEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.enter,
  );
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating || _controller.isCompleted) return;
    if (context.reduceMotion) {
      _controller.value = 1;
      return;
    }
    _timer ??= Timer(
      widget.delay + AppMotion.staggerStep * widget.index,
      _controller.forward,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: widget.offset * (1 - t),
            child: child,
          ),
        );
      },
    );
  }
}
