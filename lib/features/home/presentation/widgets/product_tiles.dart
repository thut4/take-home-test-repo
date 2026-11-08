import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/app/widgets/catalog_image.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Hero tag shared by a product tile and Product detail. [origin] keeps it
// unique when one product appears in several sections.
String productHeroTag(String origin, String productId) =>
    'product-$origin-$productId';

// One product in a section; tapping opens Product detail with a Hero flight
// of the image. [origin] names where the tile is shown and must be unique
// per screen, so the flight starts from this tile.
class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.layout,
    required this.origin,
    this.width,
  });

  final Product product;
  final SectionLayout layout;
  final String origin;

  // Defaults to the Home row size; the image keeps its proportions.
  final double? width;

  bool get _wide => layout == SectionLayout.wide;

  @override
  Widget build(BuildContext context) {
    final baseWidth = _wide
        ? AppSize.seasonalTileWidth
        : AppSize.productTileWidth;
    final baseHeight = _wide
        ? AppSize.seasonalTileHeight
        : AppSize.productTileImage;
    final width = this.width ?? baseWidth;
    final height = baseHeight * width / baseWidth;
    return AppPressable(
      key: Key('product-tile-$origin-${product.id}'),
      semanticLabel: product.name,
      onPressed: () =>
          context.push('${Routes.product(product.id)}?from=$origin'),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: _ImageFrame(product: product, wide: _wide, tag: origin),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              product.name,
              style: context.appTheme.text.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageFrame extends StatelessWidget {
  const _ImageFrame({
    required this.product,
    required this.wide,
    required this.tag,
  });

  final Product product;
  final bool wide;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final discount = product.discountPercent;
    final image = Hero(
      tag: productHeroTag(tag, product.id),
      child: CatalogImage(
        path: product.imagePath,
        fit: wide ? BoxFit.cover : BoxFit.contain,
      ),
    );
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appTheme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (wide)
            image
          else
            Padding(padding: const EdgeInsets.all(AppSpacing.md), child: image),
          if (discount != null)
            Positioned(
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: AppBadge(label: context.l10n.discountOff(discount)),
            ),
        ],
      ),
    );
  }
}
