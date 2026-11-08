import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/app/widgets/offline_banner.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/member/domain/member.dart';
import 'package:jdonuts/features/member/member_providers.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/challenge_card.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/points_ring.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/reward_tabs.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/rewards_header.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/tier_ladder.dart';
import 'package:jdonuts/features/rewards/rewards_providers.dart';
import 'package:jdonuts/features/shell/presentation/shell_metrics.dart';
import 'package:jdonuts/l10n/l10n.dart';

//EE Screen 10. Points and challenges come from the same local member record  
//EE as Home. The whole entrance replays each time the tab is opened.
class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entrance = ref.watch(rewardsEntranceProvider);
    return AdaptiveScaffold(
      backgroundColor: context.appTheme.colors.surface,
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: switch (ref.watch(currentMemberProvider)) {
              AsyncData(:final value) => KeyedSubtree(
                key: ValueKey(entrance),
                child: _RewardsBody(member: value),
              ),
              AsyncError() => AppErrorView(
                title: l10n.genericError,
                retryLabel: l10n.retry,
                onRetry: () => ref.invalidate(currentMemberProvider),
              ),
              _ => const AppShimmer(child: AppSkeletonBox()),
            },
          ),
        ],
      ),
    );
  }
}

class _RewardsBody extends StatefulWidget {
  const _RewardsBody({required this.member});

  final Member member;

  @override
  State<_RewardsBody> createState() => _RewardsBodyState();
}

class _RewardsBodyState extends State<_RewardsBody> {
  RewardTab _tab = RewardTab.earn;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return CustomScrollView(
      key: const Key('rewards-scroll'),
      slivers: [
        SliverToBoxAdapter(
          child: RewardsHeader(rewardCount: widget.member.rewardCount),
        ),
        SliverToBoxAdapter(child: _Overview(member: widget.member)),
        SliverToBoxAdapter(
          child: _TabsOnEdge(
            selected: _tab,
            onSelect: (tab) => setState(() => _tab = tab),
          ),
        ),
        SliverToBoxAdapter(
          child: ColoredBox(
            color: colors.surfaceMuted,
            child: _ChallengeList(tab: _tab),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: ColoredBox(
            color: colors.surfaceMuted,
            child: SizedBox(height: bottomNavInset(context)),
          ),
        ),
      ],
    );
  }
}

//EE Tier ladder on the left, points ring bleeding off the right edge.
class _Overview extends ConsumerWidget {
  const _Overview({required this.member});

  final Member member;

  //EE Ring diameter as a share of the width, and how much of it bleeds
  //EE past the right edge.
  static const _ringShare = 0.6;
  static const _ringOffset = 0.22;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ladder = ref.watch(tierLadderProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final diameter = width * _ringShare;
        return SizedBox(
          height: diameter + AppSpacing.xl,
          child: Stack(
            children: [
              Positioned(
                right: -diameter * _ringOffset,
                top: 0,
                child: PointsRing(
                  diameter: diameter,
                  progress: member.tierProgress,
                  totalPoints: member.totalPoints,
                ),
              ),
              Positioned(
                left: AppSpacing.screenGutter,
                top: AppSpacing.sm,
                // Stop short of the ring's left edge.
                width:
                    width -
                    diameter * (1 - _ringOffset) -
                    AppSpacing.screenGutter -
                    AppSpacing.sm,
                child: switch (ladder) {
                  AsyncData(:final value) => TierLadder(
                    steps: value,
                    progress: member.tierProgress,
                  ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

//EE The tab switch sits on the line where white meets the grey card area.
class _TabsOnEdge extends StatelessWidget {
  const _TabsOnEdge({required this.selected, required this.onSelect});

  final RewardTab selected;
  final ValueChanged<RewardTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.surface, colors.surface, colors.surfaceMuted],
          stops: const [0, 0.5, 0.5],
        ),
      ),
      child: Center(
        child: AppEntrance(
          index: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenGutter,
            ),
            child: RewardTabs(selected: selected, onSelect: onSelect),
          ),
        ),
      ),
    );
  }
}

//EE Cards for one tab. Switching tabs cross-fades and slides the list;
//EE cards enter staggered.
class _ChallengeList extends ConsumerWidget {
  const _ChallengeList({required this.tab});

  final RewardTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final direction = tab == RewardTab.earn ? -1.0 : 1.0;
    return AnimatedSwitcher(
      duration: context.motion(AppMotion.tabSwitch),
      switchInCurve: AppMotion.enter,
      switchOutCurve: AppMotion.exit,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topCenter,
        children: [...previous, ?current],
      ),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: Offset(AppMotion.sharedAxisOffset * direction, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: Padding(
        key: ValueKey(tab),
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        child: switch (ref.watch(challengesProvider(tab))) {
          AsyncData(:final value) when value.isEmpty => AppInlineMessage(
            icon: AppIcons.gift,
            message: l10n.rewardsEmpty,
          ),
          AsyncData(:final value) => Column(
            children: [
              for (final (index, challenge) in value.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: AppEntrance(
                    index: index + 4,
                    child: ChallengeCard(challenge: challenge),
                  ),
                ),
            ],
          ),
          AsyncError() => AppInlineMessage(
            icon: AppIcons.error,
            message: l10n.sectionError,
            actionLabel: l10n.retry,
            onAction: () => ref.invalidate(challengesProvider(tab)),
          ),
          _ => const AppShimmer(
            child: AppSkeletonBox(
              height: AppSize.bannerHeight,
              radius: AppRadius.xl,
            ),
          ),
        },
      ),
    );
  }
}
