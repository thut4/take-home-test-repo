import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;
import 'package:jdonuts/app/widgets/offline_banner.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/home_providers.dart';
import 'package:jdonuts/features/home/presentation/controllers/catalog_sync_controller.dart';
import 'package:jdonuts/features/home/presentation/widgets/banner_carousel.dart';
import 'package:jdonuts/features/home/presentation/widgets/home_header.dart';
import 'package:jdonuts/features/home/presentation/widgets/home_skeletons.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_section_view.dart';
import 'package:jdonuts/features/home/presentation/widgets/shops_section.dart';
import 'package:jdonuts/features/member/member_providers.dart';
import 'package:jdonuts/features/shell/presentation/shell_metrics.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Screen 8. Reads only the local database; each block has its own
// loading (skeleton), empty and error state, and blocks enter staggered.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final failure = await ref.read(catalogSyncProvider.notifier).refresh();
    if (!context.mounted) return;
    showAppSnackbar(
      context,
      failure == null ? context.l10n.refreshed : context.l10n.refreshFailed,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the sync controller keeps background refresh running.
    ref.watch(catalogSyncProvider);
    final colors = context.appTheme.colors;
    return AdaptiveScaffold(
      backgroundColor: colors.surfaceMuted,
      safeArea: false,
      body: Column(
        children: [
          ColoredBox(
            color: colors.surfaceWarm,
            child: const SafeArea(bottom: false, child: OfflineBanner()),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () => _refresh(context, ref),
              child: CustomScrollView(
                key: const Key('home-scroll'),
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: _HeaderBand()),
                  const SliverToBoxAdapter(child: _Sections()),
                  const SliverToBoxAdapter(child: _Shops()),
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomNavInset(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Peach band with the member header; the banner carousel straddles its
// bottom edge.
class _HeaderBand extends ConsumerWidget {
  const _HeaderBand();

  static const _badgeSize = 150.0;
  static const _warmShare = 0.62;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appTheme.colors;
    final member = ref.watch(currentMemberProvider);
    final banners = ref.watch(bannersProvider);
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.surfaceWarm, colors.surfaceWarm, colors.surfaceMuted],
          stops: const [0, _warmShare, _warmShare],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: -AppSpacing.xxl,
            top: -AppSpacing.xl,
            width: _badgeSize,
            height: _badgeSize,
            child: CustomPaint(painter: HeaderBadgePainter()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.listGutter,
                  AppSpacing.md,
                  AppSpacing.listGutter,
                  AppSpacing.lg,
                ),
                child: switch (member) {
                  AsyncData(:final value) => AppEntrance(
                    child: HomeHeader(member: value),
                  ),
                  AsyncError() => AppInlineMessage(
                    icon: AppIcons.error,
                    message: l10n.sectionError,
                    actionLabel: l10n.retry,
                    onAction: () => ref.invalidate(currentMemberProvider),
                  ),
                  _ => const HomeHeaderSkeleton(),
                },
              ),
              switch (banners) {
                AsyncData(:final value) when value.isEmpty =>
                  const SizedBox.shrink(),
                AsyncData(:final value) => AppEntrance(
                  index: 1,
                  child: BannerCarousel(banners: value),
                ),
                AsyncError() => _SectionError(provider: bannersProvider),
                _ => const BlockSkeleton(height: AppSize.bannerHeight),
              },
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sections extends ConsumerWidget {
  const _Sections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(sectionsProvider)) {
      AsyncData(:final value) when value.isEmpty => Padding(
        padding: const EdgeInsets.all(AppSpacing.listGutter),
        child: AppInlineMessage(
          icon: AppIcons.cart,
          message: context.l10n.sectionEmpty,
        ),
      ),
      AsyncData(:final value) => Column(
        children: [
          for (final (index, section) in value.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: AppEntrance(
                index: index + 2,
                child: ProductSectionView(section: section),
              ),
            ),
        ],
      ),
      AsyncError() => _SectionError(provider: sectionsProvider),
      _ => const SectionsSkeleton(),
    };
  }
}

class _Shops extends ConsumerWidget {
  const _Shops();

  static const _skeletonHeight = 260.0;
  static const _entranceIndex = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(shopsProvider)) {
      AsyncData(:final value) when value.isEmpty => const SizedBox.shrink(),
      AsyncData(:final value) => AppEntrance(
        index: _entranceIndex,
        child: ShopsSection(shops: value),
      ),
      AsyncError() => _SectionError(provider: shopsProvider),
      _ => const BlockSkeleton(height: _skeletonHeight),
    };
  }
}

// A block that failed to load, with retry.
class _SectionError extends ConsumerWidget {
  const _SectionError({required this.provider});

  final ProviderOrFamily provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.listGutter),
      child: AppInlineMessage(
        icon: AppIcons.error,
        message: l10n.sectionError,
        actionLabel: l10n.retry,
        onAction: () => ref.invalidate(provider),
      ),
    );
  }
}
