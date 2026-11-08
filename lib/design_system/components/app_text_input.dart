import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// White rounded field from the registration screens. The outline animates
/// to the accent colour on focus and to the error colour when [errorText]
/// is set; the message slides in below the field.
///
/// Brand-only (same on every platform): it uses Material's `TextField`
/// underneath for selection, autofill and IME handling.
class AppTextInput extends StatefulWidget {
  const AppTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.prefixText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;

  /// Fixed text before the input, such as a country code.
  final String? prefixText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// With [onTap], turns the field into a picker trigger.
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final bool enabled;

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  FocusNode? _ownFocusNode;
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(AppTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownFocusNode)?.removeListener(_onFocusChange);
      _focusNode.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _ownFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _FieldFrame(
          focused: _focusNode.hasFocus,
          hasError: error != null,
          child: _field(context),
        ),
        AnimatedSize(
          duration: context.motion(AppMotion.fieldFocus),
          curve: AppMotion.standard,
          alignment: Alignment.topCenter,
          child: error == null
              ? const SizedBox(width: double.infinity)
              : _ErrorMessage(message: error),
        ),
      ],
    );
  }

  Widget _field(BuildContext context) {
    final theme = context.appTheme;
    final prefix = widget.prefixText;
    return material.TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textCapitalization: widget.textCapitalization,
      style: theme.text.body,
      cursorColor: theme.colors.accent,
      decoration: material.InputDecoration(
        hintText: widget.hintText,
        hintStyle: theme.text.bodyMuted,
        // The frame draws the outline; clear every theme border state.
        border: material.InputBorder.none,
        enabledBorder: material.InputBorder.none,
        focusedBorder: material.InputBorder.none,
        errorBorder: material.InputBorder.none,
        focusedErrorBorder: material.InputBorder.none,
        disabledBorder: material.InputBorder.none,
        filled: false,
        isCollapsed: true,
        prefixIcon: prefix == null ? null : _Prefix(text: prefix),
        prefixIconConstraints: const BoxConstraints(),
        suffixIcon: widget.suffix,
        suffixIconConstraints: const BoxConstraints(),
      ),
    );
  }
}

class _FieldFrame extends StatelessWidget {
  const _FieldFrame({
    required this.focused,
    required this.hasError,
    required this.child,
  });

  final bool focused;
  final bool hasError;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final outline = hasError
        ? colors.error
        : focused
        ? colors.accent
        : colors.surface;
    return AnimatedContainer(
      duration: context.motion(AppMotion.fieldFocus),
      curve: AppMotion.standard,
      constraints: const BoxConstraints(minHeight: AppSize.inputHeight),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: outline, width: 1.5),
      ),
      child: child,
    );
  }
}

class _Prefix extends StatelessWidget {
  const _Prefix({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.md),
      child: Text(text, style: context.appTheme.text.bodyMuted),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.xs,
        0,
      ),
      child: Semantics(
        liveRegion: true,
        child: Text(
          message,
          style: theme.text.caption.copyWith(color: theme.colors.error),
        ),
      ),
    );
  }
}
