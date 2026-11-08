import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

class StepProgressRing extends StatefulWidget {
  const StepProgressRing({super.key, required this.step});

  static const totalSteps = 4;

  // 1-based.
  final int step;

  @override
  State<StepProgressRing> createState() => _StepProgressRingState();
}

class _StepProgressRingState extends State<StepProgressRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
        AppMotion.ringProgress +
        (_isLast ? AppMotion.ringMorph : Duration.zero),
  );

  bool get _isLast => widget.step >= StepProgressRing.totalSteps;

  // Share of the controller's time spent filling the arc.
  double get _fillShare => _isLast
      ? AppMotion.ringProgress.inMilliseconds /
            (AppMotion.ringProgress + AppMotion.ringMorph).inMilliseconds
      : 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appTheme.colors;
    return Semantics(
      label: _isLast
          ? l10n.stepsComplete
          : l10n.stepProgress(widget.step, StepProgressRing.totalSteps),
      child: SizedBox.square(
        dimension: AppSize.stepRing,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final fill = AppMotion.enter.transform(
              (t / _fillShare).clamp(0, 1),
            );
            final morph = _isLast
                ? AppMotion.emphasized.transform(
                    ((t - _fillShare) / (1 - _fillShare)).clamp(0, 1),
                  )
                : 0.0;
            return CustomPaint(
              painter: _RingPainter(
                from: (widget.step - 1) / StepProgressRing.totalSteps,
                to: widget.step / StepProgressRing.totalSteps,
                fill: fill,
                morph: morph,
                track: colors.primary.withValues(alpha: 0.45),
                arc: colors.accent,
              ),
              child: Opacity(
                opacity: morph.clamp(0, 1),
                child: Transform.scale(
                  scale: morph,
                  child: Icon(
                    AppIcons.check,
                    size: AppSize.iconSm,
                    color: colors.onAccent,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.from,
    required this.to,
    required this.fill,
    required this.morph,
    required this.track,
    required this.arc,
  });

  final double from;
  final double to;
  final double fill;
  final double morph;
  final Color track;
  final Color arc;

  static const _strokeRatio = 0.22;
  static const double _startAngle = -math.pi / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * _strokeRatio;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final progress = from + (to - from) * fill;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas
      ..drawArc(rect, 0, math.pi * 2, false, paint..color = track)
      ..drawArc(
        rect,
        _startAngle,
        math.pi * 2 * progress,
        false,
        paint..color = arc,
      );
    if (morph > 0) {
      final centre = size.center(Offset.zero);
      canvas.drawCircle(centre, size.width / 2 * morph, Paint()..color = arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fill != fill || old.morph != morph || old.track != track;
}
