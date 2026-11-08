import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/l10n/l10n.dart';

// "Eat more earn more" / "Gift" with a sky-blue indicator that slides to
// the selected tab.
class RewardTabs extends StatelessWidget {
  const RewardTabs({super.key, required this.selected, required this.onSelect});

  final RewardTab selected;
  final ValueChanged<RewardTab> onSelect;

  static const _maxWidth = 340.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: theme.colors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: theme.colors.surface, width: 3),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                alignment: selected == RewardTab.earn
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: context.motion(AppMotion.tabSwitch),
                curve: AppMotion.emphasized,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _Tab(
                  label: l10n.tabEarn,
                  tab: RewardTab.earn,
                  selected: selected,
                  onSelect: onSelect,
                ),
                _Tab(
                  label: l10n.tabGift,
                  tab: RewardTab.gift,
                  selected: selected,
                  onSelect: onSelect,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.tab,
    required this.selected,
    required this.onSelect,
  });

  final String label;
  final RewardTab tab;
  final RewardTab selected;
  final ValueChanged<RewardTab> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final isSelected = tab == selected;
    return Expanded(
      child: Semantics(
        selected: isSelected,
        child: AppPressable(
          key: Key('reward-tab-${tab.name}'),
          semanticLabel: label,
          onPressed: () => onSelect(tab),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            child: AnimatedDefaultTextStyle(
              duration: context.motion(AppMotion.tabSwitch),
              style: theme.text.subtitle.copyWith(
                color: isSelected
                    ? theme.colors.onPrimary
                    : theme.colors.onSurface,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
