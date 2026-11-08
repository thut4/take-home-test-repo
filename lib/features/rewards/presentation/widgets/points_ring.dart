import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

// The big donut ring: pink icing sweeps from 0 to [progress] while the
// total counts up from 0 to [totalPoints], on one shared controller so
// they finish together.
class PointsRing extends StatefulWidget {
  const PointsRing({
    super.key,
    required this.diameter,
    required this.progress,
    required this.totalPoints,
  });

  final double diameter;

  // 0 to 1: progress through the member's current tier.
  final double progress;
  final int totalPoints;

  @override
  State<PointsRing> createState() => _PointsRingState();
}

class _PointsRingState extends State<PointsRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pointsRing,
  );
  late final Animation<double> _sweep = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.standard,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _controller.value = 1;
    } else if (_controller.value == 0 && !_controller.isAnimating) {
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
    final theme = context.appTheme;
    final l10n = context.l10n;
    return Semantics(
      label: '${l10n.totalPoints} ${l10n.number(widget.totalPoints)}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: widget.diameter,
        child: AnimatedBuilder(
          animation: _sweep,
          builder: (context, _) => CustomPaint(
            painter: _IcingRingPainter(
              progress: widget.progress * _sweep.value,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.totalPoints,
                    style: theme.text.subtitle.copyWith(
                      color: theme.colors.accent,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      l10n.number((widget.totalPoints * _sweep.value).round()),
                      key: const Key('total-points'),
                      style: theme.text.figure.copyWith(
                        color: theme.colors.accent,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IcingRingPainter extends CustomPainter {
  _IcingRingPainter({required this.progress});

  final double progress;

  static const _thicknessRatio = 0.21;
  static const double _start = -math.pi / 2;
  static const _sprinkleCount = 22;
  static const _sprinkleSeed = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = size.width * _thicknessRatio;
    final rect = (Offset.zero & size).deflate(thickness / 2);
    final sweep = math.pi * 2 * progress;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      stroke..color = AppArtColors.ringTrack,
    );
    if (progress <= 0) return;
    stroke.shader = const SweepGradient(
      startAngle: _start,
      endAngle: _start + math.pi * 2,
      colors: [AppArtColors.ringIcingLight, AppArtColors.ringIcing],
      transform: GradientRotation(_start),
    ).createShader(rect);
    canvas.drawArc(rect, _start, sweep, false, stroke);
    _sprinkles(canvas, rect, thickness, sweep);
  }

  // Short sticks scattered along the icing, only on the swept part.
  void _sprinkles(Canvas canvas, Rect rect, double thickness, double sweep) {
    final random = math.Random(_sprinkleSeed);
    final paint = Paint()
      ..color = AppArtColors.sprinkle
      ..strokeCap = StrokeCap.round
      ..strokeWidth = thickness * 0.07;
    final radius = rect.width / 2;
    for (var i = 0; i < _sprinkleCount; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final offset = (random.nextDouble() - 0.5) * thickness * 0.6;
      final tilt = random.nextDouble() * math.pi;
      if (angle > sweep) continue;
      final centre =
          rect.center + Offset.fromDirection(_start + angle, radius + offset);
      final half = Offset.fromDirection(tilt, thickness * 0.12);
      canvas.drawLine(centre - half, centre + half, paint);
    }
  }

  @override
  bool shouldRepaint(_IcingRingPainter old) => old.progress != progress;
}
