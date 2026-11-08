import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';

// Colours of a tier's shield by tier id; unknown ids look like silver.
({Color light, Color deep}) tierColours(String tierId) => switch (tierId) {
  'bronze' => (light: AppArtColors.bronze, deep: AppArtColors.bronzeDeep),
  'gold' => (light: AppArtColors.gold, deep: AppArtColors.goldDeep),
  'platinum' => (light: AppArtColors.platinum, deep: AppArtColors.platinumDeep),
  _ => (light: AppArtColors.silver, deep: AppArtColors.silverDeep),
};

// Shield badge with the tier's initial and one star per rank.
class TierShield extends StatelessWidget {
  const TierShield({
    super.key,
    required this.tierId,
    required this.initial,
    required this.stars,
    this.size = AppSize.iconLg + AppSpacing.md,
  });

  final String tierId;
  final String initial;
  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colours = tierColours(tierId);
    return SizedBox(
      width: size,
      height: size * 1.1,
      child: CustomPaint(
        painter: _ShieldPainter(light: colours.light, deep: colours.deep),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '★' * stars,
              style: TextStyle(
                fontSize: size * 0.16,
                color: colours.deep,
                height: 1,
              ),
            ),
            Text(
              initial,
              style: context.appTheme.text.title.copyWith(
                color: colours.deep,
                fontSize: size * 0.36,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  _ShieldPainter({required this.light, required this.deep});

  final Color light;
  final Color deep;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shield = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.72, h * 0.08, w * 0.88, h * 0.1, w, h * 0.12)
      ..lineTo(w, h * 0.5)
      ..cubicTo(w, h * 0.78, w * 0.7, h * 0.92, w * 0.5, h)
      ..cubicTo(w * 0.3, h * 0.92, 0, h * 0.78, 0, h * 0.5)
      ..lineTo(0, h * 0.12)
      ..cubicTo(w * 0.12, h * 0.1, w * 0.28, h * 0.08, w * 0.5, 0)
      ..close();
    final rect = Offset.zero & size;
    canvas
      ..drawPath(
        shield,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [light, deep],
          ).createShader(rect),
      )
      ..drawPath(
        shield,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.06
          ..color = light,
      );
  }

  @override
  bool shouldRepaint(_ShieldPainter old) =>
      old.light != light || old.deep != deep;
}
