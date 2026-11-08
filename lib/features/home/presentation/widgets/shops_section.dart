import 'package:flutter/widgets.dart';
import 'package:jdonuts/app/widgets/catalog_image.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/l10n/l10n.dart';

// "There are 4 J'Donut shops near you." on the sky-blue band with hills.
// Display only: Explore now and Order online have no action.
class ShopsSection extends StatelessWidget {
  const ShopsSection({super.key, required this.shops});

  final List<Shop> shops;

  static const _hillsHeight = 90.0;
  static const _emoji = ' 😋';

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colors.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: _hillsHeight,
            child: CustomPaint(painter: _HillsPainter()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenGutter,
                  AppSpacing.xl,
                  AppSpacing.screenGutter,
                  AppSpacing.md,
                ),
                child: Text(
                  '${l10n.shopsTitle(shops.length)}$_emoji',
                  style: theme.text.title.copyWith(
                    color: theme.colors.onPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenGutter,
                ),
                child: _PillLabel(text: l10n.exploreNow.toUpperCase()),
              ),
              const SizedBox(height: AppSpacing.lg),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenGutter,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (index, shop) in shops.indexed) ...[
                      if (index > 0) const SizedBox(width: AppSpacing.md),
                      _ShopCard(shop: shop),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  const _PillLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: theme.text.label.copyWith(color: theme.colors.primary),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop});

  final Shop shop;

  static const _imageHeight = 110.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      width: AppSize.shopCardWidth,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogImage(
            path: shop.imagePath,
            height: _imageHeight,
            width: double.infinity,
            borderRadius: AppRadius.md,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(shop.name, style: theme.text.subtitle),
          const SizedBox(height: AppSpacing.xxs),
          Text(shop.address, style: theme.text.caption, maxLines: 2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.orderOnline,
            style: theme.text.caption.copyWith(
              color: theme.colors.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// Two rolling hills along the bottom of the shops band.
class _HillsPainter extends CustomPainter {
  const _HillsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final back = Path()
      ..moveTo(0, h * 0.45)
      ..quadraticBezierTo(w * 0.3, 0, w * 0.62, h * 0.4)
      ..quadraticBezierTo(w * 0.85, h * 0.65, w, h * 0.3)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    final front = Path()
      ..moveTo(0, h * 0.75)
      ..quadraticBezierTo(w * 0.45, h * 0.35, w, h * 0.7)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas
      ..drawPath(back, Paint()..color = AppArtColors.hillLight)
      ..drawPath(front, Paint()..color = AppArtColors.hillDark);
  }

  @override
  bool shouldRepaint(_HillsPainter oldDelegate) => false;
}
