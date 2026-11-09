import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/rewards/rewards_providers.dart';
import 'package:jdonuts/l10n/l10n.dart';

// The five tabs, in branch order.
enum ShellTab { home, reward, order, wallet, settings }

// Frame around the tabs: the active branch, with the sky-blue bottom bar
// floating over it.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _select(WidgetRef ref, int index) {
    if (index == ShellTab.reward.index) {
      ref.read(rewardsEntranceProvider.notifier).replay();
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The bar sits outside any page scaffold, so give it a text style.
    return DefaultTextStyle(
      style: context.appTheme.text.body,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppSnackbarInset(
              bottom: AppSize.bottomNavHeight,
              child: navigationShell,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              current: ShellTab.values[navigationShell.currentIndex],
              onSelect: (tab) => _select(ref, tab.index),
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom navigation: icons on sky blue, with a pink pill (icon + label)
// that slides to the active tab.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.current,
    required this.onSelect,
  });

  final ShellTab current;
  final ValueChanged<ShellTab> onSelect;

  static const double _pillInset = AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Container(
      height: AppSize.bottomNavHeight + bottom,
      padding: EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, bottom),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slot = constraints.maxWidth / ShellTab.values.length;
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              AnimatedPositioned(
                duration: context.motion(AppMotion.navPill),
                curve: AppMotion.emphasized,
                left: slot * current.index + _pillInset,
                width: slot - _pillInset * 2,
                top: AppSpacing.md,
                bottom: AppSpacing.md,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: colors.onAccent, width: 1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final tab in ShellTab.values)
                    Expanded(
                      child: _NavItem(
                        tab: tab,
                        isActive: tab == current,
                        onTap: () => onSelect(tab),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final ShellTab tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    final (icon, label) = switch (tab) {
      ShellTab.home => (AppIcons.home, l10n.navHome),
      ShellTab.reward => (AppIcons.reward, l10n.navReward),
      ShellTab.order => (AppIcons.order, l10n.navOrder),
      ShellTab.wallet => (AppIcons.wallet, l10n.navWallet),
      ShellTab.settings => (AppIcons.settings, l10n.navSettings),
    };
    final colour = isActive ? theme.colors.onAccent : theme.colors.onPrimary;
    return Semantics(
      selected: isActive,
      child: AppPressable(
        key: Key('nav-${tab.name}'),
        semanticLabel: label,
        onPressed: onTap,
        child: Container(
          height: AppSize.bottomNavHeight,
          // Keep the label inside the pill, which is inset from the slot.
          padding: const EdgeInsets.symmetric(
            horizontal: BottomNavBar._pillInset + AppSpacing.xs,
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: colour, size: AppSize.iconMd - 2),
                  AnimatedSize(
                    duration: context.motion(AppMotion.navPill),
                    curve: AppMotion.standard,
                    child: isActive
                        ? Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.xs),
                            child: Text(
                              label,
                              style: theme.text.caption.copyWith(
                                color: colour,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
