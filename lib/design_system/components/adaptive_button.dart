import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/adaptive_loading_indicator.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

enum AdaptiveButtonVariant {
  // Filled with the primary colour: the main action on a screen.
  primary,

  // Lower emphasis than [primary].
  secondary,

  // No container: navigation bar actions and inline links.
  text,
}

// Text button with three emphasis levels.
//
// Disabled when [onPressed] is null or [isLoading] is true. While loading,
// a spinner replaces the label; the label keeps the width and stays in
// semantics.
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AdaptiveButtonVariant.primary;

  const AdaptiveButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AdaptiveButtonVariant.secondary;

  const AdaptiveButton.text({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expand = false,
  }) : variant = AdaptiveButtonVariant.text;

  final String label;
  final VoidCallback? onPressed;
  final AdaptiveButtonVariant variant;
  final bool isLoading;

  // Fill the available width.
  final bool expand;

  bool get isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final callback = isEnabled ? onPressed : null;
    final child = Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: !isLoading,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          maintainSemantics: true,
          child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (isLoading)
          AdaptiveLoadingIndicator(
            size: AdaptiveLoadingIndicatorSize.small,
            color: colors.onSurfaceMuted,
          ),
      ],
    );

    final Widget button;
    if (useCupertino) {
      final radius = BorderRadius.circular(AppRadius.md);
      const minimumSize = Size(AppSize.minTouchTarget, AppSize.buttonHeight);
      button = switch (variant) {
        AdaptiveButtonVariant.primary => cupertino.CupertinoButton.filled(
          color: colors.primary,
          foregroundColor: colors.onPrimary,
          borderRadius: radius,
          minimumSize: minimumSize,
          onPressed: callback,
          child: child,
        ),
        // Difference: Cupertino's native secondary style is a tinted fill,
        // where Material uses an outline.
        AdaptiveButtonVariant.secondary => cupertino.CupertinoButton.tinted(
          color: colors.primary,
          foregroundColor: colors.primary,
          borderRadius: radius,
          minimumSize: minimumSize,
          onPressed: callback,
          child: child,
        ),
        AdaptiveButtonVariant.text => cupertino.CupertinoButton(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          minimumSize: const Size.square(AppSize.minTouchTarget),
          onPressed: callback,
          child: child,
        ),
      };
    } else {
      button = switch (variant) {
        AdaptiveButtonVariant.primary => material.FilledButton(
          onPressed: callback,
          child: child,
        ),
        AdaptiveButtonVariant.secondary => material.OutlinedButton(
          onPressed: callback,
          child: child,
        ),
        AdaptiveButtonVariant.text => material.TextButton(
          onPressed: callback,
          child: child,
        ),
      };
    }

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
