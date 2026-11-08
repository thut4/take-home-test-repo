import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/app/locale_controller.dart';
import 'package:jdonuts/app/router.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

class JDonutsApp extends ConsumerWidget {
  const JDonutsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AdaptiveApp(
      routerConfig: ref.watch(routerProvider),
      title: "J'Donuts",
      themeMode: AppThemeMode.light,
      locale: ref.watch(localeControllerProvider),
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
