import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/l10n/l10n.dart';

// − 1 + pill. The number slides up when it grows and down when it
// shrinks. Minimum [QuantityLimits.min].
class QuantityStepper extends StatefulWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  bool _increasing = true;

  void _change(int delta) {
    final next = QuantityLimits.clamp(widget.quantity + delta);
    if (next == widget.quantity) return;
    setState(() => _increasing = delta > 0);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: theme.colors.surfaceMuted, width: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundButton(
            key: const Key('quantity-decrease'),
            icon: AppIcons.remove,
            label: l10n.decreaseQuantity,
            onPressed: widget.quantity > QuantityLimits.min
                ? () => _change(-1)
                : null,
          ),
          SizedBox(
            width: AppSpacing.xxxl,
            child: Semantics(
              liveRegion: true,
              label: l10n.quantityValue(widget.quantity),
              excludeSemantics: true,
              child: _AnimatedNumber(
                value: widget.quantity,
                increasing: _increasing,
              ),
            ),
          ),
          _RoundButton(
            key: const Key('quantity-increase'),
            icon: AppIcons.add,
            label: l10n.increaseQuantity,
            onPressed: widget.quantity < QuantityLimits.max
                ? () => _change(1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _AnimatedNumber extends StatelessWidget {
  const _AnimatedNumber({required this.value, required this.increasing});

  final int value;
  final bool increasing;

  @override
  Widget build(BuildContext context) {
    final direction = increasing ? 1.0 : -1.0;
    return ClipRect(
      child: AnimatedSwitcher(
        duration: context.motion(AppMotion.quantityChange),
        switchInCurve: AppMotion.enter,
        switchOutCurve: AppMotion.exit,
        transitionBuilder: (child, animation) {
          final incoming = child.key == ValueKey(value);
          final begin = Offset(0, incoming ? direction : -direction);
          return SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Text(
          '$value',
          key: ValueKey(value),
          textAlign: TextAlign.center,
          style: context.appTheme.text.title,
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return AppPressable(
      onPressed: onPressed,
      semanticLabel: label,
      child: AnimatedOpacity(
        opacity: onPressed == null ? 0.4 : 1,
        duration: context.motion(AppMotion.fast),
        child: Container(
          width: AppSize.iconLg,
          height: AppSize.iconLg,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colors.onPrimary, size: AppSize.iconMd),
        ),
      ),
    );
  }
}
