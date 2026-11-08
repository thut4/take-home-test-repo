import 'package:flutter/widgets.dart';

import 'package:jdonuts/design_system/tokens/color_tokens.dart';
import 'package:jdonuts/design_system/tokens/typography_tokens.dart';

// Which colour scheme the app uses.
enum AppThemeMode { system, light, dark }

// Theme values screens read through `context.appTheme`.
@immutable
class AppThemeData {
  AppThemeData.from(this.colors) : text = AppTextStyles.from(colors);

  final AppColorScheme colors;
  final AppTextStyles text;

  Brightness get brightness => colors.brightness;

  // [text] is derived from [colors], so colors alone decide equality.
  @override
  bool operator ==(Object other) =>
      other is AppThemeData && other.colors == colors;

  @override
  int get hashCode => colors.hashCode;
}

// Provides [AppThemeData] to the tree. Inserted by `AdaptiveApp`.
class AppThemeScope extends InheritedWidget {
  const AppThemeScope({required this.data, required super.child, super.key});

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppThemeScope>();
    assert(
      scope != null,
      'No AppThemeScope found. Wrap the app in AdaptiveApp.',
    );
    return scope!.data;
  }

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) => data != oldWidget.data;
}

extension AppThemeContext on BuildContext {
  AppThemeData get appTheme => AppThemeScope.of(this);
}
