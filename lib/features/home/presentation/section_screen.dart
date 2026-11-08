import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/widgets/offline_banner.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/features/home/home_providers.dart';
import 'package:jdonuts/features/home/presentation/widgets/home_skeletons.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_section_view.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_tiles.dart';
import 'package:jdonuts/features/shell/presentation/shell_metrics.dart';
import 'package:jdonuts/l10n/l10n.dart';

// "See all" for one Home section (`/home/section/:id`). It lives in the
// Home tab, so the bottom bar stays, and reads only the local database.
class SectionScreen extends ConsumerWidget {
  const SectionScreen({super.key, required this.sectionId});

  final String sectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    final state = ref.watch(sectionProvider(sectionId));
    final section = state.value;
    return AdaptiveScaffold(
      backgroundColor: theme.colors.surfaceMuted,
      safeArea: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SafeArea(bottom: false, child: OfflineBanner()),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.listGutter,
              AppSpacing.md,
              AppSpacing.listGutter,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                AppBackButton(onPressed: () => context.pop()),
                const SizedBox(width: AppSpacing.md),
                if (section != null)
                  Expanded(
                    child: Text(
                      sectionHeading(section),
                      style: theme.text.title,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              AsyncData(value: final ProductSection section)
                  when section.products.isEmpty =>
                const _EmptySection(),
              AsyncData(value: final ProductSection section) => _SectionGrid(
                section: section,
              ),
              AsyncData() => AppErrorView(title: l10n.sectionNotFound),
              AsyncError() => AppErrorView(
                title: l10n.sectionError,
                retryLabel: l10n.retry,
                onRetry: () => ref.invalidate(sectionProvider(sectionId)),
              ),
              _ => const _LoadingSection(),
            },
          ),
        ],
      ),
    );
  }
}

// Wide sections stack full-width tiles; card sections use two columns. A
// wrap, not a fixed-ratio grid, so two-line names never clip at large text.
class _SectionGrid extends StatelessWidget {
  const _SectionGrid({required this.section});

  final ProductSection section;

  static const _cardColumns = 2;

  @override
  Widget build(BuildContext context) {
    final columns = section.layout == SectionLayout.wide ? 1 : _cardColumns;
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = constraints.maxWidth - AppSpacing.listGutter * 2;
        // Floored so rounding can't push the last column onto a new run.
        final tileWidth = ((content - AppSpacing.md * (columns - 1)) / columns)
            .floorToDouble();
        return SingleChildScrollView(
          key: const Key('section-scroll'),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.listGutter,
            0,
            AppSpacing.listGutter,
            bottomNavInset(context),
          ),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.lg,
            children: [
              for (final (index, product) in section.products.indexed)
                AppEntrance(
                  index: index,
                  child: ProductTile(
                    product: product,
                    layout: section.layout,
                    // Not the Home id: a shared hero tag would fly every
                    // matching Home tile into this page when it opens.
                    origin: 'all-${section.id}',
                    width: tileWidth,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.listGutter,
          ),
          child: AppInlineMessage(
            icon: AppIcons.cart,
            message: context.l10n.sectionEmpty,
          ),
        ),
      ],
    );
  }
}

class _LoadingSection extends StatelessWidget {
  const _LoadingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [BlockSkeleton(height: AppSize.bannerHeight)],
    );
  }
}
