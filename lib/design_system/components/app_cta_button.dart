import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/adaptive_loading_indicator.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/components/app_pressable.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';

/// Colour of an [AppCtaButton].
enum AppCtaTone { primary, accent }

/// Full-width pill call to action ("CONTINUE", "LET'S EXPLORE", "ADD TO
/// CART"). Scales on press and morphs into a round loading state while
/// [isLoading]; taps are ignored while loading, so a double tap sends one
/// request.
class AppCtaButton extends StatelessWidget {
  const AppCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.trailing,
    this.tone = AppCtaTone.primary,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final bool isLoading;

  /// Optional text after a divider, such as a live total.
  final String? trailing;
  final AppCtaTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final fill = tone == AppCtaTone.primary ? colors.primary : colors.accent;
    final enabled = onPressed != null && !isLoading;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = isLoading ? AppSize.buttonHeight : constraints.maxWidth;
        return Center(
          child: AppPressable(
            onPressed: enabled ? onPressed : null,
            semanticLabel: label,
            child: AnimatedContainer(
              duration: context.motion(AppMotion.buttonMorph),
              curve: AppMotion.standard,
              width: width,
              height: AppSize.buttonHeight,
              decoration: BoxDecoration(
                color: onPressed == null ? fill.withValues(alpha: 0.45) : fill,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: _content(context),
            ),
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    final colors = context.appTheme.colors;
    return AnimatedSwitcher(
      duration: context.motion(AppMotion.fast),
      child: isLoading
          ? Center(
              key: const ValueKey('loading'),
              child: AdaptiveLoadingIndicator(color: colors.onPrimary),
            )
          : _Label(label: label, trailing: trailing),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final style = theme.text.label.copyWith(color: theme.colors.onPrimary);
    final trailing = this.trailing;
    return Row(
      key: const ValueKey('label'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label.toUpperCase(),
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) ...[
          Container(
            width: 1,
            height: AppSpacing.lg,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            color: theme.colors.onPrimary.withValues(alpha: 0.6),
          ),
          Text(trailing, style: style, maxLines: 1),
        ],
      ],
    );
  }
}
