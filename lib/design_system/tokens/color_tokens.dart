import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Raw J'Donuts palette, read off the 10 design screens. Screens never use
/// these directly; they read a role from [AppColorScheme] (or, for painted
/// artwork, [AppArtColors]).
abstract final class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  static const Color ink900 = Color(0xFF1F1D2B);
  static const Color ink700 = Color(0xFF3F3B4C);
  static const Color ink500 = Color(0xFF8C8798);
  static const Color ink300 = Color(0xFFC4C0CC);

  static const Color sky500 = Color(0xFF3FC3E4);
  static const Color sky400 = Color(0xFF56CFEA);
  static const Color sky100 = Color(0xFFDDF5FB);

  static const Color pink600 = Color(0xFFE2457F);
  static const Color pink500 = Color(0xFFF0569A);
  static const Color pink300 = Color(0xFFF7A1C4);
  static const Color pink100 = Color(0xFFFCE6F0);
  static const Color pink50 = Color(0xFFFDF3F8);

  static const Color orange500 = Color(0xFFFF7A1A);
  static const Color orange100 = Color(0xFFFFE9D6);
  static const Color peach100 = Color(0xFFFDE3CF);

  static const Color mist200 = Color(0xFFDCE4E4);
  static const Color mist100 = Color(0xFFE9EFEF);
  static const Color mist50 = Color(0xFFF4F7F7);

  static const Color grape500 = Color(0xFF6B63C7);
  static const Color leaf500 = Color(0xFF7BB83A);
  static const Color grey200 = Color(0xFFE6E6E9);

  static const Color red500 = Color(0xFFE5484D);
  static const Color red300 = Color(0xFFFF8589);
  static const Color green600 = Color(0xFF2F9E5B);
  static const Color green400 = Color(0xFF5FD18B);

  static const Color night950 = Color(0xFF15131C);
  static const Color night900 = Color(0xFF1E1B27);
  static const Color night800 = Color(0xFF2A2634);
  static const Color night700 = Color(0xFF3A3546);
}

/// Semantic colour roles. Every role exists in both [light] and [dark].
@immutable
class AppColorScheme {
  const AppColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.highlight,
    required this.onHighlight,
    required this.background,
    required this.backgroundBlush,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceWarm,
    required this.surfaceFeature,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.border,
    required this.disabled,
    required this.onDisabled,
    required this.positive,
    required this.error,
    required this.onError,
    required this.success,
  });

  final Brightness brightness;

  /// Sky blue: primary buttons, bottom navigation bar.
  final Color primary;
  final Color onPrimary;

  /// Donut pink: links, progress, active navigation pill, totals.
  final Color accent;
  final Color onAccent;

  /// Orange: discount and New badges, the Rewards pill, coffee progress.
  final Color highlight;
  final Color onHighlight;

  /// Page background.
  final Color background;

  /// Pink wash used behind onboarding and registration.
  final Color backgroundBlush;

  /// Cards, inputs, sheets.
  final Color surface;

  /// Grey-blue page behind Home sections, Product detail and challenges.
  final Color surfaceMuted;

  /// Peach member header on Home.
  final Color surfaceWarm;

  /// Purple feature banner.
  final Color surfaceFeature;

  final Color onSurface;
  final Color onSurfaceMuted;
  final Color border;

  /// Disabled controls (for example an Earn button that can't be used yet).
  final Color disabled;
  final Color onDisabled;

  /// Small "what's this" marker and success ticks.
  final Color positive;

  final Color error;
  final Color onError;
  final Color success;

  static const AppColorScheme light = AppColorScheme(
    brightness: Brightness.light,
    primary: AppColors.sky400,
    onPrimary: AppColors.white,
    accent: AppColors.pink500,
    onAccent: AppColors.white,
    highlight: AppColors.orange500,
    onHighlight: AppColors.white,
    background: AppColors.white,
    backgroundBlush: AppColors.pink100,
    surface: AppColors.white,
    surfaceMuted: AppColors.mist100,
    surfaceWarm: AppColors.peach100,
    surfaceFeature: AppColors.grape500,
    onSurface: AppColors.ink900,
    onSurfaceMuted: AppColors.ink500,
    border: AppColors.mist200,
    disabled: AppColors.grey200,
    onDisabled: AppColors.white,
    positive: AppColors.leaf500,
    error: AppColors.red500,
    onError: AppColors.white,
    success: AppColors.green600,
  );

  /// The designs are light-only; the app pins [light]. Dark values exist so
  /// the design system stays complete.
  static const AppColorScheme dark = AppColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.sky400,
    onPrimary: AppColors.night950,
    accent: AppColors.pink300,
    onAccent: AppColors.night950,
    highlight: AppColors.orange500,
    onHighlight: AppColors.night950,
    background: AppColors.night950,
    backgroundBlush: AppColors.night900,
    surface: AppColors.night900,
    surfaceMuted: AppColors.night800,
    surfaceWarm: AppColors.night800,
    surfaceFeature: AppColors.grape500,
    onSurface: AppColors.mist50,
    onSurfaceMuted: AppColors.ink300,
    border: AppColors.night700,
    disabled: AppColors.night700,
    onDisabled: AppColors.ink500,
    positive: AppColors.leaf500,
    error: AppColors.red300,
    onError: AppColors.night950,
    success: AppColors.green400,
  );
}

/// Colours for painted artwork (tier shields, progress art, decorative
/// sprinkles). Kept out of [AppColorScheme] because they don't change with
/// the theme.
abstract final class AppArtColors {
  static const Color silver = Color(0xFFC9CDD3);
  static const Color silverDeep = Color(0xFF9DA3AB);
  static const Color gold = Color(0xFFF4D77E);
  static const Color goldDeep = Color(0xFFD9AE3E);
  static const Color platinum = Color(0xFFA9E3F3);
  static const Color platinumDeep = Color(0xFF5FC2E0);
  static const Color bronze = Color(0xFFE2A97A);
  static const Color bronzeDeep = Color(0xFFB87645);

  static const Color ringIcing = AppColors.pink500;
  static const Color ringIcingLight = Color(0xFFF77DB5);
  static const Color ringTrack = AppColors.mist100;
  static const Color sprinkle = Color(0xFFFFD1E4);

  static const Color tileBlue = Color(0xFFB9D9EE);
  static const Color tilePink = Color(0xFFF9CFE0);
  static const Color tilePeach = Color(0xFFF7DEC6);
  static const Color tileYellow = Color(0xFFFFC34D);
  static const Color tileCyan = Color(0xFF6ADCF0);

  static const List<Color> sprinkles = [
    Color(0xFF5CC8EC),
    Color(0xFFF0569A),
    Color(0xFFFFD640),
    Color(0xFF7AC45A),
    Color(0xFFFFFFFF),
  ];

  static const Color hillLight = Color(0xFFA6DA74);
  static const Color hillDark = Color(0xFF6FBF4C);
  static const Color cloud = AppColors.white;
  static const Color headerBadge = Color(0xFFF9D2B6);
  static const Color headerStar = Color(0xFFA79C97);
  static const Color offlineBar = AppColors.ink900;

  static const Color skeletonBase = AppColors.mist100;
  static const Color skeletonShine = AppColors.mist50;
}
