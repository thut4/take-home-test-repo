import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/features/rewards/presentation/widgets/challenge_art.dart';
import 'package:jdonuts/l10n/l10n.dart';

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.challenge});

  final Challenge challenge;

  static const _artSize = 112.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    final isGift = challenge.tab == RewardTab.gift;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          ChallengeArt(challenge: challenge, size: _artSize),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(challenge.title, style: theme.text.title),
                if (!isGift)
                  Text(
                    l10n.challengeProgress(challenge.progress, challenge.goal),
                    style: theme.text.body,
                  ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    EarnButton(
                      key: Key('earn-${challenge.id}'),
                      label: isGift ? l10n.redeem : l10n.earn,
                      isActive: challenge.isComplete,
                      onPressed: () => showAppSnackbar(
                        context,
                        isGift ? l10n.redeemTapped : l10n.earnTapped,
                      ),
                    ),
                    Text(
                      l10n.pointsShort(l10n.number(challenge.points)),
                      style: theme.text.body,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Earn: sky blue with a gentle pulse when the challenge is complete, grey
/// otherwise. Both scale on press; only the active one does anything.
class EarnButton extends StatefulWidget {
  const EarnButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  State<EarnButton> createState() => _EarnButtonState();
}

class _EarnButtonState extends State<EarnButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppMotion.attentionPulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(EarnButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    if (widget.isActive && !context.reduceMotion) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final fill = widget.isActive ? theme.colors.primary : theme.colors.disabled;
    return AppPressable(
      semanticLabel: widget.label,
      onPressed: widget.isActive ? widget.onPressed : () {},
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final t = AppMotion.standard.transform(_pulse.value);
          return Transform.scale(
            scale: 1 + (AppMotion.attentionScale - 1) * t,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: theme.colors.primary.withValues(alpha: 0.45 * t),
                    blurRadius: AppSpacing.lg * t,
                    spreadRadius: AppSpacing.xxs * t,
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: theme.text.label.copyWith(color: theme.colors.onPrimary),
          ),
        ),
      ),
    );
  }
}
