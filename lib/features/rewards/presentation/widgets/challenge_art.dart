import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:jdonuts/app/widgets/catalog_image.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';

// Progress artwork for a challenge card, animated from empty to
// [Challenge.fraction] when the card appears.
class ChallengeArt extends StatelessWidget {
  const ChallengeArt({super.key, required this.challenge, required this.size});

  final Challenge challenge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final image = CatalogImage(
      path: challenge.imagePath,
      fit: BoxFit.contain,
      width: size,
      height: size,
    );
    if (challenge.artwork == ChallengeArtwork.gift) {
      return SizedBox.square(dimension: size, child: image);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: challenge.fraction),
      duration: context.motion(AppMotion.challengeArt),
      curve: AppMotion.standard,
      builder: (context, value, _) => SizedBox.square(
        dimension: size,
        child: switch (challenge.artwork) {
          ChallengeArtwork.coffee => _CoffeeArc(fraction: value, image: image),
          _ => _DonutQuarters(fraction: value, image: image),
        },
      ),
    );
  }
}

// A grey donut that colours in clockwise from the top: 1/4, 2/4, ...
class _DonutQuarters extends StatelessWidget {
  const _DonutQuarters({required this.fraction, required this.image});

  final double fraction;
  final Widget image;

  // Desaturates and lightens, so the uncoloured part reads as plain dough.
  static const _greyscale = ColorFilter.matrix([
    0.33, 0.33, 0.33, 0, 40, //
    0.33, 0.33, 0.33, 0, 40, //
    0.33, 0.33, 0.33, 0, 40, //
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(colorFilter: _greyscale, child: image),
        ClipPath(clipper: _SweepClipper(fraction), child: image),
      ],
    );
  }
}

class _SweepClipper extends CustomClipper<Path> {
  _SweepClipper(this.fraction);

  final double fraction;

  @override
  Path getClip(Size size) {
    if (fraction >= 1) return Path()..addRect(Offset.zero & size);
    final centre = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: centre, radius: size.longestSide);
    return Path()
      ..moveTo(centre.dx, centre.dy)
      ..arcTo(rect, -math.pi / 2, math.pi * 2 * fraction, false)
      ..close();
  }

  @override
  bool shouldReclip(_SweepClipper old) => old.fraction != fraction;
}

// A cup with an arc over it that fills left to right (9/12, ...).
class _CoffeeArc extends StatelessWidget {
  const _CoffeeArc({required this.fraction, required this.image});

  final double fraction;
  final Widget image;

  static const _cupScale = 0.78;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return CustomPaint(
      painter: _ArcPainter(
        fraction: fraction,
        track: colors.surfaceMuted,
        fill: colors.highlight,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          widthFactor: _cupScale,
          heightFactor: _cupScale,
          child: image,
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.fraction,
    required this.track,
    required this.fill,
  });

  final double fraction;
  final Color track;
  final Color fill;

  static const double _start = math.pi * 0.95;
  static const double _sweep = math.pi * 1.1;
  static const _strokeRatio = 0.09;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * _strokeRatio;
    final rect = (Offset.zero & size).deflate(stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, _sweep, false, paint..color = track);
    if (fraction > 0) {
      canvas.drawArc(
        rect,
        _start,
        _sweep * fraction,
        false,
        paint..color = fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.fraction != fraction;
}
