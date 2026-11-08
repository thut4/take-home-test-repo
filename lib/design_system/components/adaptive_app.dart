import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/color_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

// Root widget. Builds a Material or Cupertino app from the same tokens and
// provides `context.appTheme` to every route.
class AdaptiveApp extends StatelessWidget {
  // Router-based app (for example go_router).
  const AdaptiveApp({
    required RouterConfig<Object> this.routerConfig,
    super.key,
    this.title = '',
    this.locale,
    this.themeMode = AppThemeMode.system,
    this.lightColors = AppColorScheme.light,
    this.darkColors = AppColorScheme.dark,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en', 'US')],
    this.debugShowCheckedModeBanner = true,
  }) : home = null;

  // App with a single home widget and imperative navigation.
  const AdaptiveApp.home({
    required Widget this.home,
    super.key,
    this.title = '',
    this.locale,
    this.themeMode = AppThemeMode.system,
    this.lightColors = AppColorScheme.light,
    this.darkColors = AppColorScheme.dark,
    this.localizationsDelegates,
    this.supportedLocales = const [Locale('en', 'US')],
    this.debugShowCheckedModeBanner = true,
  }) : routerConfig = null;

  final RouterConfig<Object>? routerConfig;
  final Widget? home;
  final String title;

  // Null follows the device locale.
  final Locale? locale;
  final AppThemeMode themeMode;
  final AppColorScheme lightColors;
  final AppColorScheme darkColors;

  // Use `GlobalMaterialLocalizations` / `GlobalCupertinoLocalizations` from
  // `material_ui` / `cupertino_ui`, not from `flutter_localizations`.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  // The app's own delegates plus the Material, Cupertino and widgets ones
  // from `material_ui` (which replace `flutter_localizations`'s).
  List<LocalizationsDelegate<dynamic>> get _delegates => [
    ...?localizationsDelegates,
    ...material.GlobalMaterialLocalizations.delegates,
  ];
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context) {
    return useCupertino ? _buildCupertino() : _buildMaterial();
  }

  Widget _buildMaterial() {
    // MaterialApp resolves light/dark itself; the scope follows the theme it
    // picked so both always agree.
    Widget builder(BuildContext context, Widget? child) {
      final isDark = material.Theme.of(context).brightness == Brightness.dark;
      return AppThemeScope(
        data: AppThemeData.from(isDark ? darkColors : lightColors),
        child: child!,
      );
    }

    final theme = AppTheme.toMaterial(lightColors);
    final darkTheme = AppTheme.toMaterial(darkColors);
    final mode = switch (themeMode) {
      AppThemeMode.system => material.ThemeMode.system,
      AppThemeMode.light => material.ThemeMode.light,
      AppThemeMode.dark => material.ThemeMode.dark,
    };

    final config = routerConfig;
    if (config != null) {
      return material.MaterialApp.router(
        routerConfig: config,
        title: title,
        theme: theme,
        darkTheme: darkTheme,
        themeMode: mode,
        builder: builder,
        localizationsDelegates: _delegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }
    return material.MaterialApp(
      home: home,
      title: title,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: mode,
      builder: builder,
      localizationsDelegates: _delegates,
      supportedLocales: supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }

  Widget _buildCupertino() {
    // CupertinoApp takes one theme, so resolve brightness below its
    // MediaQuery and override the theme there.
    Widget builder(BuildContext context, Widget? child) {
      final isDark = switch (themeMode) {
        AppThemeMode.system =>
          MediaQuery.platformBrightnessOf(context) == Brightness.dark,
        AppThemeMode.light => false,
        AppThemeMode.dark => true,
      };
      final colors = isDark ? darkColors : lightColors;
      return AppThemeScope(
        data: AppThemeData.from(colors),
        child: cupertino.CupertinoTheme(
          data: AppTheme.toCupertino(colors),
          child: child!,
        ),
      );
    }

    final config = routerConfig;
    if (config != null) {
      return cupertino.CupertinoApp.router(
        routerConfig: config,
        title: title,
        color: lightColors.primary,
        builder: builder,
        localizationsDelegates: _delegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      );
    }
    return cupertino.CupertinoApp(
      home: home,
      title: title,
      color: lightColors.primary,
      builder: builder,
      localizationsDelegates: _delegates,
      supportedLocales: supportedLocales,
      locale: locale,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
    );
  }
}
