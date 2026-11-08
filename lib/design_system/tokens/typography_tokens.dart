import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'package:jdonuts/design_system/tokens/color_tokens.dart';

enum FontWeightToken {
  regular(FontWeight.w400),
  medium(FontWeight.w500),
  semibold(FontWeight.w600),
  bold(FontWeight.w700),
  extraBold(FontWeight.w800);

  const FontWeightToken(this.value);

  final FontWeight value;
}

/// One text style as a design tool reports it: sizes in logical pixels.
@immutable
class TypeStyle {
  const TypeStyle({
    required this.fontSize,
    required this.lineHeight,
    this.weight = FontWeightToken.regular,
    this.letterSpacing = 0,
  });

  final double fontSize;

  /// Line height in pixels (not a ratio). [toTextStyle] converts it.
  final double lineHeight;
  final FontWeightToken weight;
  final double letterSpacing;

  TextStyle toTextStyle({Color? color}) => TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: fontSize,
    height: lineHeight / fontSize,
    fontWeight: weight.value,
    letterSpacing: letterSpacing,
    color: color,
  );
}

/// J'Donuts type scale, measured on a 375-pt-wide frame.
abstract final class AppTypography {
  /// Bundled in assets/fonts (SIL Open Font Licence), so text renders the
  /// same offline on first launch. Myanmar script falls back to the system
  /// font.
  static const String fontFamily = 'Urbanist';

  /// "Round food for every mood", "Welcome to the world of J'donuts".
  static const TypeStyle display = TypeStyle(
    fontSize: 30,
    lineHeight: 36,
    weight: FontWeightToken.extraBold,
    letterSpacing: -0.3,
  );

  /// Step titles ("Enter your phone number"), "J' Donuts Rewards".
  static const TypeStyle headline = TypeStyle(
    fontSize: 26,
    lineHeight: 32,
    weight: FontWeightToken.extraBold,
    letterSpacing: -0.2,
  );

  /// Section headers on Home, product names on detail.
  static const TypeStyle title = TypeStyle(
    fontSize: 18,
    lineHeight: 24,
    weight: FontWeightToken.bold,
  );

  /// Card titles: product tiles, shop names, challenge names.
  static const TypeStyle subtitle = TypeStyle(
    fontSize: 14,
    lineHeight: 18,
    weight: FontWeightToken.bold,
  );

  static const TypeStyle body = TypeStyle(fontSize: 15, lineHeight: 22);

  /// Uppercase call-to-action labels ("CONTINUE", "ADD TO CART").
  static const TypeStyle label = TypeStyle(
    fontSize: 13,
    lineHeight: 16,
    weight: FontWeightToken.extraBold,
    letterSpacing: 1.4,
  );

  static const TypeStyle caption = TypeStyle(fontSize: 12, lineHeight: 16);

  /// Large figures: total points, quantity, OTP digits.
  static const TypeStyle figure = TypeStyle(
    fontSize: 28,
    lineHeight: 34,
    weight: FontWeightToken.extraBold,
  );
}

/// Resolved text styles for one colour scheme, read via
/// `context.appTheme.text`.
@immutable
class AppTextStyles {
  const AppTextStyles({
    required this.display,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodyMuted,
    required this.label,
    required this.caption,
    required this.figure,
  });

  factory AppTextStyles.from(AppColorScheme colors) => AppTextStyles(
    display: AppTypography.display.toTextStyle(color: colors.onSurface),
    headline: AppTypography.headline.toTextStyle(color: colors.onSurface),
    title: AppTypography.title.toTextStyle(color: colors.onSurface),
    subtitle: AppTypography.subtitle.toTextStyle(color: colors.onSurface),
    body: AppTypography.body.toTextStyle(color: colors.onSurface),
    bodyMuted: AppTypography.body.toTextStyle(color: colors.onSurfaceMuted),
    label: AppTypography.label.toTextStyle(color: colors.onSurface),
    caption: AppTypography.caption.toTextStyle(color: colors.onSurfaceMuted),
    figure: AppTypography.figure.toTextStyle(color: colors.onSurface),
  );

  final TextStyle display;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodyMuted;
  final TextStyle label;
  final TextStyle caption;
  final TextStyle figure;
}
