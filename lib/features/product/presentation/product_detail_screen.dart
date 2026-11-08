import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/widgets/catalog_image.dart';
import 'package:jdonuts/app/widgets/offline_banner.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_tiles.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/features/product/presentation/widgets/quantity_stepper.dart';
import 'package:jdonuts/features/product/product_providers.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Screen 9 (`/product/:id`). [heroOrigin] is the section the tile was in,
// so the image flies from the right tile.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.heroOrigin,
  });

  final String productId;
  final String? heroOrigin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appTheme.colors;
    final l10n = context.l10n;
    return AdaptiveScaffold(
      backgroundColor: colors.surfaceMuted,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const OfflineBanner(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenGutter,
              AppSpacing.md,
              AppSpacing.screenGutter,
              0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppBackButton(onPressed: () => context.pop()),
            ),
          ),
          Expanded(
            child: switch (ref.watch(productProvider(productId))) {
              AsyncData(:final value) => _ProductBody(
                product: value,
                heroTag: productHeroTag(heroOrigin ?? 'direct', value.id),
              ),
              AsyncError(:final error) => AppErrorView(
                title: error is NotFoundFailure
                    ? l10n.productNotFound
                    : l10n.genericError,
                retryLabel: l10n.retry,
                onRetry: () => ref.invalidate(productProvider(productId)),
              ),
              _ => const _ProductSkeleton(),
            },
          ),
        ],
      ),
    );
  }
}

class _ProductBody extends ConsumerStatefulWidget {
  const _ProductBody({required this.product, required this.heroTag});

  final Product product;
  final String heroTag;

  @override
  ConsumerState<_ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends ConsumerState<_ProductBody> {
  int _quantity = QuantityLimits.min;
  bool _adding = false;

  Future<void> _addToCart() async {
    setState(() => _adding = true);
    final result = await ref
        .read(productRepositoryProvider)
        .addToCart(widget.product.id, _quantity);
    if (!mounted) return;
    setState(() => _adding = false);
    final l10n = context.l10n;
    showAppSnackbar(context, switch (result) {
      Ok() => l10n.addedToCart(_quantity, widget.product.name),
      Err(:final failure) => l10n.failureMessage(failure),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final product = widget.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenGutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Flexible(
            flex: 3,
            child: _ProductCard(
              product: product,
              heroTag: widget.heroTag,
              stepper: QuantityStepper(
                quantity: _quantity,
                onChanged: (value) => setState(() => _quantity = value),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Flexible(flex: 2, child: _Description(text: product.description)),
          const SizedBox(height: AppSpacing.lg),
          AppCtaButton(
            key: const Key('add-to-cart'),
            label: l10n.addToCart,
            trailing: l10n.mmk(product.totalFor(_quantity)),
            isLoading: _adding,
            onPressed: _addToCart,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.heroTag,
    required this.stepper,
  });

  final Product product;
  final String heroTag;
  final Widget stepper;

  static const double _stepperOverlap = AppSize.iconLg / 2 + AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: _stepperOverlap),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          decoration: BoxDecoration(
            color: theme.colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(product.code, style: theme.text.caption),
                  ),
                  if (product.isNew) AppBadge(label: l10n.newBadge),
                ],
              ),
              Text(product.name, style: theme.text.headline),
              Text(l10n.mmk(product.priceMmk), style: theme.text.subtitle),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Hero(
                  tag: heroTag,
                  child: CatalogImage(
                    path: product.imagePath,
                    fit: BoxFit.contain,
                    semanticLabel: product.name,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(left: 0, right: 0, bottom: 0, child: Center(child: stepper)),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSize.productTileWidth / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSize.iconSm,
                height: AppSize.iconSm,
                decoration: BoxDecoration(
                  color: theme.colors.positive,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.help,
                  size: AppSpacing.md,
                  color: theme.colors.surface,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(context.l10n.whatsThis, style: theme.text.subtitle),
            ],
          ),
        ),
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          color: theme.colors.border,
        ),
        Expanded(child: _FadingText(text: text)),
      ],
    );
  }
}

// Scrollable description that fades out at the bottom edge.
class _FadingText extends StatelessWidget {
  const _FadingText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colors.onSurface,
          theme.colors.onSurface.withValues(alpha: 0),
        ],
        stops: const [0.7, 1],
      ).createShader(bounds),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: Text(text, style: theme.text.bodyMuted),
        ),
      ),
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenGutter),
      child: AppShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: AppSkeletonBox(radius: AppRadius.xl)),
            SizedBox(height: AppSpacing.xl),
            Expanded(child: AppSkeletonBox()),
            SizedBox(height: AppSpacing.xl),
            AppSkeletonBox(
              height: AppSize.buttonHeight,
              radius: AppRadius.pill,
            ),
          ],
        ),
      ),
    );
  }
}
