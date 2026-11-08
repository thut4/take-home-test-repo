import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Title, and the orange Rewards pill whose count pops in.
class RewardsHeader extends StatelessWidget {
  const RewardsHeader({super.key, required this.rewardCount});

  final int rewardCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.lg),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.screenGutter),
          Expanded(
            child: AppEntrance(
              child: Text(l10n.rewardsTitle, style: theme.text.headline),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.screenGutter,
              AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colors.highlight,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadius.pill),
              ),
            ),
            child: Row(
              children: [
                Text(
                  l10n.rewardsPill,
                  style: theme.text.subtitle.copyWith(
                    color: theme.colors.onHighlight,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _PopBadge(count: rewardCount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PopBadge extends StatelessWidget {
  const _PopBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final reduce = context.reduceMotion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduce ? 1 : 0, end: 1),
      duration: context.motion(AppMotion.badgePop + AppMotion.badgeDelay),
      builder: (context, t, child) {
        final delayShare =
            AppMotion.badgeDelay.inMilliseconds /
            (AppMotion.badgePop + AppMotion.badgeDelay).inMilliseconds;
        final local = ((t - delayShare) / (1 - delayShare)).clamp(0.0, 1.0);
        return Transform.scale(
          scale: reduce ? 1 : AppMotion.spring.transform(local),
          child: child,
        );
      },
      child: Container(
        key: const Key('rewards-badge'),
        padding: const EdgeInsets.all(AppSpacing.xs + AppSpacing.xxs),
        decoration: BoxDecoration(
          color: theme.colors.surface,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$count',
          style: theme.text.caption.copyWith(
            color: theme.colors.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
