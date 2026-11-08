import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// Single-line text input with optional label and error text.
class AdaptiveTextField extends StatelessWidget {
  const AdaptiveTextField({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? label;
  final String? placeholder;

  /// Shown below the field; also switches the outline to the error colour.
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final label = this.label;
    final errorText = this.errorText;

    if (!useCupertino) {
      return material.TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        autofocus: autofocus,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: theme.text.body,
        decoration: material.InputDecoration(
          labelText: label,
          hintText: placeholder,
          errorText: errorText,
        ),
      );
    }

    // Difference: CupertinoTextField has no label or error slot. The label
    // sits above the field and the error below it, outside the border.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label, style: theme.text.caption),
          const SizedBox(height: AppSpacing.xs),
        ],
        cupertino.CupertinoTextField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          placeholder: placeholder,
          placeholderStyle: theme.text.bodyMuted,
          style: theme.text.body,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(
              color: errorText != null ? colors.error : colors.border,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText,
            style: theme.text.caption.copyWith(color: colors.error),
          ),
        ],
      ],
    );
  }
}
