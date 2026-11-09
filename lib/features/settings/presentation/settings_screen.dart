import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/app/locale_controller.dart';
import 'package:jdonuts/app/widgets/offline_banner.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';
import 'package:jdonuts/features/member/member_providers.dart';
import 'package:jdonuts/features/member/presentation/widgets/member_header.dart';
import 'package:jdonuts/features/shell/presentation/shell_metrics.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Settings tab, styled like Home: the member on the peach band, then the
// language switch and Log out on the grey page.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _logOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showAdaptiveConfirmDialog(
      context,
      title: l10n.logOutConfirmTitle,
      message: l10n.logOutConfirmBody,
      confirmLabel: l10n.logOut,
      cancelLabel: l10n.cancel,
      isDestructive: true,
    );
    if (!confirmed) return;
    final failure = await ref.read(sessionControllerProvider.notifier).logOut();
    if (failure != null && context.mounted) {
      showAppSnackbar(context, context.l10n.failureMessage(failure));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    return AdaptiveScaffold(
      backgroundColor: theme.colors.surfaceMuted,
      safeArea: false,
      body: Column(
        children: [
          ColoredBox(
            color: theme.colors.surfaceWarm,
            child: const SafeArea(bottom: false, child: OfflineBanner()),
          ),
          Expanded(
            child: ListView(
              key: const Key('settings-scroll'),
              padding: EdgeInsets.only(bottom: bottomNavInset(context)),
              children: [
                const _ProfileBand(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.listGutter,
                    AppSpacing.xl,
                    AppSpacing.listGutter,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppEntrance(
                        index: 1,
                        child: Text(
                          context.l10n.settingsTitle,
                          style: theme.text.title,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const AppEntrance(index: 2, child: _LanguageRow()),
                      const SizedBox(height: AppSpacing.xl),
                      AppEntrance(
                        index: 3,
                        child: AppCtaButton(
                          key: const Key('logout-button'),
                          label: context.l10n.logOut,
                          tone: AppCtaTone.accent,
                          onPressed: () => _logOut(context, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Peach band with the same member header and badge as Home.
class _ProfileBand extends ConsumerWidget {
  const _ProfileBand();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final session = ref.watch(sessionControllerProvider);
    return ColoredBox(
      color: context.appTheme.colors.surfaceWarm,
      child: Stack(
        children: [
          const Positioned(
            right: -AppSpacing.xxl,
            top: -AppSpacing.xl,
            width: HeaderBadgePainter.size,
            height: HeaderBadgePainter.size,
            child: CustomPaint(painter: HeaderBadgePainter()),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.listGutter,
              AppSpacing.md,
              AppSpacing.listGutter,
              AppSpacing.xxl,
            ),
            child: switch (ref.watch(currentMemberProvider)) {
              AsyncData(:final value) => AppEntrance(
                child: MemberHeader(
                  member: value,
                  showBell: false,
                  statusLabel: session is SignedIn
                      ? l10n.signedInAs(session.account.phone)
                      : null,
                ),
              ),
              AsyncError() => AppInlineMessage(
                icon: AppIcons.error,
                message: l10n.sectionError,
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(currentMemberProvider),
              ),
              _ => const MemberHeaderSkeleton(),
            },
          ),
        ],
      ),
    );
  }
}

// White card with the language toggle; a tap anywhere switches language.
class _LanguageRow extends ConsumerWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context);
    return MergeSemantics(
      child: Semantics(
        value: l10n.languageName,
        child: AppPressable(
          key: const Key('language-row'),
          onPressed: () =>
              ref.read(localeControllerProvider.notifier).toggle(locale),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Container(
                  width: AppSize.minTouchTarget,
                  height: AppSize.minTouchTarget,
                  decoration: BoxDecoration(
                    color: colors.surfaceWarm,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(AppIcons.language, color: colors.highlight),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(l10n.language, style: theme.text.subtitle),
                ),
                const SizedBox(width: AppSpacing.sm),
                ExcludeSemantics(
                  child: _LanguageToggle(
                    isBurmese: locale.languageCode == 'my',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Two-way toggle with a pink thumb that slides to the active language.
class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.isBurmese});

  final bool isBurmese;

  // Each language is written in its own script, so these aren't translated.
  static const _english = 'English';
  static const _burmese = 'မြန်မာ';

  // Leaves the "Language" title room on small phones with large text.
  static const _maxWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return Container(
      constraints: const BoxConstraints(maxWidth: _maxWidth),
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      // Both halves take the width of the longer label.
      child: IntrinsicWidth(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                alignment: isBurmese
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                duration: context.motion(AppMotion.tabSwitch),
                curve: AppMotion.standard,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                _ToggleLabel(label: _english, isActive: !isBurmese),
                _ToggleLabel(label: _burmese, isActive: isBurmese),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleLabel extends StatelessWidget {
  const _ToggleLabel({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: AnimatedDefaultTextStyle(
          duration: context.motion(AppMotion.tabSwitch),
          style: theme.text.caption.copyWith(
            color: isActive ? theme.colors.onAccent : theme.colors.onSurface,
            fontWeight: FontWeight.w700,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, maxLines: 1),
          ),
        ),
      ),
    );
  }
}
