import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/adaptive_button.dart';
import 'package:jdonuts/design_system/components/adaptive_loading_indicator.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';

/// Full-screen loading state.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return _StateLayout(
      children: [
        const AdaptiveLoadingIndicator(
          size: AdaptiveLoadingIndicatorSize.large,
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            message,
            style: context.appTheme.text.bodyMuted,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Full-screen error state with an optional retry action.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.retryLabel = 'Try again',
    this.onRetry,
  });

  final String title;
  final String? message;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final onRetry = this.onRetry;
    return _MessageView(
      title: title,
      message: message,
      action: onRetry == null
          ? null
          : AdaptiveButton.secondary(label: retryLabel, onPressed: onRetry),
    );
  }
}

/// Full-screen empty state with an optional action.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    super.key,
    this.message,
    this.actionLabel,
    this.onAction,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'Provide both actionLabel and onAction, or neither.',
       );

  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final actionLabel = this.actionLabel;
    return _MessageView(
      title: title,
      message: message,
      action: actionLabel == null
          ? null
          : AdaptiveButton(label: actionLabel, onPressed: onAction),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.title, this.message, this.action});

  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.text;
    final message = this.message;
    final action = this.action;
    return _StateLayout(
      children: [
        Text(title, style: text.title, textAlign: TextAlign.center),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: text.bodyMuted, textAlign: TextAlign.center),
        ],
        if (action != null) ...[const SizedBox(height: AppSpacing.xl), action],
      ],
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenGutter),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

/// Compact message for one section of a screen (an empty list, a section
/// that failed to load), with an optional action.
class AppInlineMessage extends StatelessWidget {
  const AppInlineMessage({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final actionLabel = this.actionLabel;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colors.onSurfaceMuted),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(message, style: theme.text.bodyMuted)),
          if (actionLabel != null)
            AdaptiveButton.text(label: actionLabel, onPressed: onAction),
        ],
      ),
    );
  }
}
