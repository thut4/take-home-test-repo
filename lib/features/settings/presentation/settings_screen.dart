import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/app/locale_controller.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Settings tab: the account, the language switch and Log out.
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
    final l10n = context.l10n;
    final session = ref.watch(sessionControllerProvider);
    final locale = Localizations.localeOf(context);
    return AdaptiveScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        children: [
          if (session case SignedIn(:final account))
            AdaptiveListTile(
              title: account.displayName,
              subtitle: l10n.signedInAs(account.phone),
            ),
          AdaptiveListTile(
            key: const Key('language-row'),
            leading: const Icon(AppIcons.language),
            title: l10n.language,
            trailing: Text(l10n.languageName),
            onTap: () =>
                ref.read(localeControllerProvider.notifier).toggle(locale),
          ),
          AdaptiveListTile(
            key: const Key('logout-row'),
            leading: const Icon(AppIcons.logout),
            title: l10n.logOut,
            onTap: () => _logOut(context, ref),
          ),
        ],
      ),
    );
  }
}
