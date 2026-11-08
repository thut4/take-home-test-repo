import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_tiles.dart';
import 'package:jdonuts/l10n/l10n.dart';

// A titled horizontal list ("Seasonal specials", "Popular", ...).
class ProductSectionView extends StatelessWidget {
  const ProductSectionView({super.key, required this.section});

  final ProductSection section;

  static const _flame = ' 🔥';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: section.showFlame ? '${section.title}$_flame' : section.title,
          onMore: () => showAppSnackbar(context, l10n.comingSoonBody),
          moreLabel: l10n.seeAll(section.title),
        ),
        const SizedBox(height: AppSpacing.md),
        if (section.products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.listGutter),
            child: _EmptySection(),
          )
        else
          _ProductRow(section: section),
      ],
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.section});

  final ProductSection section;

  @override
  Widget build(BuildContext context) {
    // Height follows the text scale so two-line names never clip.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.listGutter),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, product) in section.products.indexed) ...[
            if (index > 0) const SizedBox(width: AppSpacing.md),
            ProductTile(
              product: product,
              layout: section.layout,
              sectionId: section.id,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) =>
      AppInlineMessage(icon: AppIcons.cart, message: context.l10n.sectionEmpty);
}

// Section title with the round chevron button on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onMore,
    this.moreLabel,
  });

  final String title;
  final VoidCallback? onMore;
  final String? moreLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.listGutter),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.text.title)),
          if (onMore != null)
            AppPressable(
              onPressed: onMore,
              semanticLabel: moreLabel,
              child: Container(
                width: AppSize.iconLg - AppSpacing.sm,
                height: AppSize.iconLg - AppSpacing.sm,
                decoration: BoxDecoration(
                  color: theme.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.chevronRight,
                  size: AppSize.iconSm + AppSpacing.xs,
                  color: theme.colors.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
