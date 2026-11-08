import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/color_tokens.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// One-time-code boxes. A single hidden text field drives all boxes, so:
/// typing advances to the next box, backspace moves back, pasting fills
/// every box, the keyboard is numeric and iOS/Android can autofill the
/// code from an SMS. Brand-only (same on every platform).
class AppCodeInput extends StatefulWidget {
  const AppCodeInput({
    super.key,
    required this.controller,
    required this.onCompleted,
    required this.semanticLabel,
    this.length = 6,
    this.focusNode,
    this.enabled = true,
    this.hasError = false,
    this.shakeCount = 0,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final String semanticLabel;
  final int length;
  final FocusNode? focusNode;
  final bool enabled;
  final bool hasError;

  /// Increment to shake the boxes once (wrong code).
  final int shakeCount;

  @override
  State<AppCodeInput> createState() => _AppCodeInputState();
}

class _AppCodeInputState extends State<AppCodeInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: AppMotion.shake,
  );
  FocusNode? _ownFocus;
  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(AppCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shakeCount != oldWidget.shakeCount) {
      _shake.duration = context.motion(AppMotion.shake);
      _shake.forward(from: 0);
    }
  }

  String _lastText = '';

  void _onChanged() {
    setState(() {});
    final code = widget.controller.text;
    if (code == _lastText) return;
    _lastText = code;
    if (code.length == widget.length) widget.onCompleted(code);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.removeListener(_onChanged);
    _ownFocus?.dispose();
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeOffset(_shake.value), 0),
        child: child,
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _hiddenField()),
          IgnorePointer(child: _boxes(context)),
        ],
      ),
    );
  }

  /// A damped sine: three swings that settle back to zero.
  static double _shakeOffset(double t) =>
      math.sin(t * math.pi * 2 * AppMotion.shakeCycles) *
      AppMotion.shakeDistance *
      (1 - t);

  Widget _hiddenField() {
    return Semantics(
      label: widget.semanticLabel,
      child: material.TextField(
        controller: widget.controller,
        focusNode: _focus,
        enabled: widget.enabled,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.oneTimeCode],
        maxLength: widget.length,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        showCursor: false,
        enableInteractiveSelection: true,
        style: const TextStyle(color: AppColors.transparent, fontSize: 1),
        decoration: const material.InputDecoration(
          border: material.InputBorder.none,
          enabledBorder: material.InputBorder.none,
          focusedBorder: material.InputBorder.none,
          disabledBorder: material.InputBorder.none,
          counterText: '',
          filled: false,
        ),
      ),
    );
  }

  Widget _boxes(BuildContext context) {
    final code = widget.controller.text;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < widget.length; i++)
          _CodeBox(
            digit: i < code.length ? code[i] : '',
            isActive: _focus.hasFocus && i == code.length,
            hasError: widget.hasError,
            enabled: widget.enabled,
          ),
      ],
    );
  }
}

class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.digit,
    required this.isActive,
    required this.hasError,
    required this.enabled,
  });

  final String digit;
  final bool isActive;
  final bool hasError;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final border = hasError
        ? theme.colors.error
        : isActive
        ? theme.colors.accent
        : theme.colors.surface;
    return Flexible(
      child: AnimatedContainer(
        duration: context.motion(AppMotion.fieldFocus),
        curve: AppMotion.standard,
        constraints: const BoxConstraints(maxWidth: AppSize.otpBox),
        height: AppSize.otpBox,
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled
              ? theme.colors.surface
              : theme.colors.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: border, width: 1.5),
        ),
        child: AnimatedSwitcher(
          duration: context.motion(AppMotion.fast),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(digit, key: ValueKey(digit), style: theme.text.title),
        ),
      ),
    );
  }
}
