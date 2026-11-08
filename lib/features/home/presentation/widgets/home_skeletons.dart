import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';

// Placeholder sections while Home's lists load: same shapes as the real
// tiles, under one shimmer.
class SectionsSkeleton extends StatelessWidget {
  const SectionsSkeleton({super.key});

  static const _sections = 3;
  static const _tiles = 3;
  static const _titleWidth = 140.0;
  static const _nameWidth = 100.0;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var s = 0; s < _sections; s++) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.listGutter),
              child: AppSkeletonBox(width: _titleWidth, height: AppSpacing.xl),
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.listGutter,
              ),
              child: Row(
                children: [
                  for (var t = 0; t < _tiles; t++) ...[
                    if (t > 0) const SizedBox(width: AppSpacing.md),
                    const _TileSkeleton(),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSkeletonBox(
          width: AppSize.productTileWidth,
          height: AppSize.productTileImage,
          radius: AppRadius.lg,
        ),
        SizedBox(height: AppSpacing.sm),
        AppSkeletonBox(
          width: SectionsSkeleton._nameWidth,
          height: AppSpacing.md,
        ),
      ],
    );
  }
}

// Placeholder for the banner carousel and the shops band.
class BlockSkeleton extends StatelessWidget {
  const BlockSkeleton({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.listGutter),
        child: AppSkeletonBox(height: height, radius: AppRadius.xl),
      ),
    );
  }
}
