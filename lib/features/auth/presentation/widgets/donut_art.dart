import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';

// A coloured disc with a donut on it and a few painted sprinkles.
class DonutCircle extends StatelessWidget {
  const DonutCircle({
    super.key,
    required this.diameter,
    required this.colors,
    required this.donutAsset,
    this.donutScale = 0.68,
    this.sprinkleSeed,
  });

  final double diameter;

  // Top and bottom of a diagonal two-tone fill.
  final List<Color> colors;
  final String donutAsset;
  final double donutScale;

  // Null draws no sprinkles.
  final int? sprinkleSeed;

  @override
  Widget build(BuildContext context) {
    final seed = sprinkleSeed;
    return SizedBox.square(
      dimension: diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
            stops: const [0.55, 0.55],
          ),
        ),
        child: CustomPaint(
          painter: seed == null ? null : SprinklePainter(seed: seed),
          child: Center(
            child: Image.asset(
              donutAsset,
              width: diameter * donutScale,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}

// Short rounded sticks scattered around the edge of the canvas.
class SprinklePainter extends CustomPainter {
  SprinklePainter({required this.seed, this.count = 9, this.colors});

  final int seed;
  final int count;
  final List<Color>? colors;

  static const _lengthRatio = 0.09;
  static const _widthRatio = 0.025;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(seed);
    final palette = colors ?? const [AppArtColors.sprinkle];
    final length = size.shortestSide * _lengthRatio;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.shortestSide * _widthRatio;
    for (var i = 0; i < count; i++) {
      final angle = random.nextDouble() * math.pi * 2;
      final radius = size.shortestSide * (0.36 + random.nextDouble() * 0.1);
      final centre = size.center(Offset.fromDirection(angle, radius));
      final tilt = Offset.fromDirection(random.nextDouble() * math.pi, length);
      paint.color = palette[i % palette.length];
      canvas.drawLine(centre - tilt / 2, centre + tilt / 2, paint);
    }
  }

  @override
  bool shouldRepaint(SprinklePainter old) => old.seed != seed;
}

// Gentle up-and-down bob, out of phase per [phase]. Still under Reduce
// Motion.
class IdleFloat extends StatefulWidget {
  const IdleFloat({super.key, required this.child, this.phase = 0});

  final Widget child;
  final double phase;

  @override
  State<IdleFloat> createState() => _IdleFloatState();
}

class _IdleFloatState extends State<IdleFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.idleFloat,
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
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final wave = math.sin((_controller.value + widget.phase) * math.pi * 2);
        return Transform.translate(
          offset: Offset(0, wave * AppMotion.idleFloatDistance),
          child: child,
        );
      },
    );
  }
}
