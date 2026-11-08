import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/tier_shield.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Silver → Gold → Platinum. Tiers appear one after another, the current
// one is highlighted, and the line up to the next tier fills to show the
// member's [progress].
class TierLadder extends StatelessWidget {
  const TierLadder({super.key, required this.steps, required this.progress});

  final List<LadderStep> steps;
  final double progress;

  static const double _connectorHeight = AppSpacing.xxxl + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, step) in steps.indexed) ...[
          AppEntrance(
            index: index * 2,
            offset: const Offset(-AppMotion.entranceOffset, 0),
            duration: AppMotion.tierStep,
            child: _Rung(step: step),
          ),
          if (index < steps.length - 1)
            _Connector(
              fill: step.status == LadderStatus.current
                  ? progress
                  : step.status == LadderStatus.reached
                  ? 1
                  : 0,
              delay: AppMotion.staggerStep * (index * 2 + 1),
            ),
        ],
      ],
    );
  }
}

class _Rung extends StatelessWidget {
  const _Rung({required this.step});

  final LadderStep step;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    final isCurrent = step.status == LadderStatus.current;
    final subtitle = switch (step.status) {
      LadderStatus.current => l10n.tierHereNow,
      LadderStatus.next => l10n.tierRemaining(
        l10n.number(step.pointsRemaining),
        step.tier.name,
      ),
      LadderStatus.later => l10n.tierSoon,
      LadderStatus.reached => l10n.tierReached,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedScale(
          scale: isCurrent ? 1 : 0.86,
          duration: context.motion(AppMotion.medium),
          child: TierShield(
            tierId: step.tier.id,
            initial: step.tier.name.characters.first,
            stars: step.tier.rank,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.tier.name,
                style: theme.text.subtitle.copyWith(
                  color: isCurrent
                      ? theme.colors.accent
                      : theme.colors.onSurface,
                ),
              ),
              Text(subtitle, style: theme.text.caption),
            ],
          ),
        ),
      ],
    );
  }
}

// Vertical line between two shields that fills top-down to [fill].
class _Connector extends StatelessWidget {
  const _Connector({required this.fill, required this.delay});

  final double fill;
  final Duration delay;

  static const _width = 3.0;
  static const double _shieldCentre = (AppSize.iconLg + AppSpacing.md) / 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return Padding(
      padding: const EdgeInsets.only(left: _shieldCentre - _width / 2),
      child: SizedBox(
        width: _width,
        height: TierLadder._connectorHeight,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: colors.border)),
            AppEntrance(
              delay: delay,
              offset: Offset.zero,
              duration: AppMotion.tierLineFill,
              child: _GrowDown(fill: fill, colour: colors.onSurfaceMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrowDown extends StatelessWidget {
  const _GrowDown({required this.fill, required this.colour});

  final double fill;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: fill),
      duration: context.motion(AppMotion.tierLineFill),
      curve: AppMotion.standard,
      builder: (context, value, _) => FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: value,
        widthFactor: 1,
        child: ColoredBox(color: colour),
      ),
    );
  }
}
