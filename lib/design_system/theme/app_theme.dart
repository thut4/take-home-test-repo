import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/tokens/color_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:jdonuts/design_system/tokens/typography_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

// Maps design tokens onto both renderers. Every token a component relies on
// must be mapped in [toMaterial] and [toCupertino].
abstract final class AppTheme {
  static material.ThemeData toMaterial(AppColorScheme c) {
    final text = AppTextStyles.from(c);
    final buttonShape = material.RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
    );
    const buttonMinSize = Size(64, AppSize.buttonHeight);
    const buttonPadding = EdgeInsets.symmetric(horizontal: AppSpacing.lg);
    final buttonText = AppTypography.label.toTextStyle();

    return material.ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: material.ColorScheme(
        brightness: c.brightness,
        primary: c.primary,
        onPrimary: c.onPrimary,
        secondary: c.accent,
        onSecondary: c.onAccent,
        tertiary: c.highlight,
        onTertiary: c.onHighlight,
        error: c.error,
        onError: c.onError,
        surface: c.surface,
        onSurface: c.onSurface,
        onSurfaceVariant: c.onSurfaceMuted,
        outline: c.border,
        outlineVariant: c.border,
      ),
      scaffoldBackgroundColor: c.background,
      dividerColor: c.border,
      textTheme: material.TextTheme(
        displaySmall: text.display,
        headlineSmall: text.headline,
        titleLarge: text.title,
        titleMedium: text.subtitle,
        bodyLarge: text.body,
        bodyMedium: text.body,
        bodySmall: text.caption,
        labelLarge: text.label,
      ),
      appBarTheme: material.AppBarThemeData(
        backgroundColor: c.background,
        foregroundColor: c.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: text.title,
      ),
      filledButtonTheme: material.FilledButtonThemeData(
        style: material.FilledButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: material.OutlinedButtonThemeData(
        style: material.OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          side: BorderSide(color: c.border),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: material.TextButtonThemeData(
        style: material.TextButton.styleFrom(
          foregroundColor: c.primary,
          minimumSize: const Size(
            AppSize.minTouchTarget,
            AppSize.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      inputDecorationTheme: material.InputDecorationThemeData(
        filled: true,
        fillColor: c.surface,
        hintStyle: text.bodyMuted,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: _outline(c.border),
        enabledBorder: _outline(c.border),
        focusedBorder: _outline(c.primary, width: 2),
        errorBorder: _outline(c.error),
        focusedErrorBorder: _outline(c.error, width: 2),
      ),
      dialogTheme: material.DialogThemeData(
        backgroundColor: c.surface,
        titleTextStyle: text.title,
        contentTextStyle: text.body,
        shape: material.RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      listTileTheme: material.ListTileThemeData(
        textColor: c.onSurface,
        iconColor: c.onSurfaceMuted,
        titleTextStyle: text.body,
        subtitleTextStyle: text.caption,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenGutter,
        ),
      ),
      progressIndicatorTheme: material.ProgressIndicatorThemeData(
        color: c.primary,
      ),
      textSelectionTheme: material.TextSelectionThemeData(
        cursorColor: c.accent,
        selectionColor: c.accent.withValues(alpha: 0.3),
        selectionHandleColor: c.accent,
      ),
      snackBarTheme: material.SnackBarThemeData(
        backgroundColor: c.onSurface,
        contentTextStyle: text.body.copyWith(color: c.surface),
        behavior: material.SnackBarBehavior.floating,
        shape: material.RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      bottomSheetTheme: material.BottomSheetThemeData(
        backgroundColor: c.surface,
        showDragHandle: true,
        shape: const material.RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
    );
  }

  static cupertino.CupertinoThemeData toCupertino(AppColorScheme c) {
    final text = AppTextStyles.from(c);
    return cupertino.CupertinoThemeData(
      brightness: c.brightness,
      primaryColor: c.primary,
      primaryContrastingColor: c.onPrimary,
      scaffoldBackgroundColor: c.background,
      barBackgroundColor: c.background,
      textTheme: cupertino.CupertinoTextThemeData(
        primaryColor: c.primary,
        textStyle: text.body,
        actionTextStyle: text.label.copyWith(color: c.primary),
        actionSmallTextStyle: text.caption.copyWith(color: c.primary),
        navTitleTextStyle: text.title,
        navLargeTitleTextStyle: text.headline,
        navActionTextStyle: text.body.copyWith(color: c.primary),
      ),
    );
  }

  static material.OutlineInputBorder _outline(Color color, {double width = 1}) {
    return material.OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
