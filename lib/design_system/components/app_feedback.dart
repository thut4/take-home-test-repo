import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_cta_button.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// Small pill label ("New", "50% off").
class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.background});

  final String label;

  /// Defaults to the highlight (orange) role.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: background ?? theme.colors.highlight,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.text.caption.copyWith(
          color: theme.colors.onHighlight,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Brief message at the bottom of the screen.
void showAppSnackbar(BuildContext context, String message) {
  material.ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(material.SnackBar(content: Text(message)));
}

/// Placeholder bottom sheet for features outside the test's scope
/// (social sign-in, legal pages).
Future<void> showAppInfoSheet(
  BuildContext context, {
  required String title,
  required String message,
  required String closeLabel,
}) {
  return material.showModalBottomSheet<void>(
    context: context,
    builder: (context) =>
        _InfoSheet(title: title, message: message, closeLabel: closeLabel),
  );
}

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({
    required this.title,
    required this.message,
    required this.closeLabel,
  });

  final String title;
  final String message;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.text;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenGutter,
          0,
          AppSpacing.screenGutter,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.title),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: text.bodyMuted),
            const SizedBox(height: AppSpacing.xl),
            AppCtaButton(
              label: closeLabel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pull-to-refresh in the brand colours.
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return material.RefreshIndicator(
      onRefresh: onRefresh,
      color: colors.accent,
      backgroundColor: colors.surface,
      child: child,
    );
  }
}
