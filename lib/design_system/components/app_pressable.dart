import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';

/// Scales [child] down while pressed. Disabled when [onPressed] is null.
/// Same on every platform.
class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.child,
    required this.onPressed,
    this.pressedScale = AppMotion.pressedScale,
    this.semanticLabel,
    this.isButton = true,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double pressedScale;
  final String? semanticLabel;

  /// Announce as a button to screen readers.
  final bool isButton;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Semantics(
      button: widget.isButton,
      enabled: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: enabled ? () => _setPressed(false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? widget.pressedScale : 1,
          duration: context.motion(AppMotion.press),
          curve: AppMotion.standard,
          child: widget.child,
        ),
      ),
    );
  }
}
