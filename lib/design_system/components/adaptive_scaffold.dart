import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// Page frame: navigation bar, body and an optional pinned [bottomBar]
/// (typically the primary call to action).
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.body,
    super.key,
    this.title,
    this.actions = const [],
    this.bottomBar,
    this.backgroundColor,
    this.background,
    this.safeArea = true,
  });

  /// Navigation bar title. With no title and no actions, no bar is shown.
  final String? title;

  /// Trailing navigation bar items, usually `AdaptiveButton.text`.
  final List<Widget> actions;

  /// Page content. Already inside a safe area; add [AppSpacing.screenGutter]
  /// horizontal padding where needed.
  final Widget body;

  /// Pinned to the bottom, padded by the gutter and above the home indicator.
  final Widget? bottomBar;

  /// Page colour; defaults to the background role.
  final Color? backgroundColor;

  /// Painted behind [body], full-bleed (gradients, artwork).
  final Widget? background;

  /// Wrap [body] in a SafeArea. Off for screens that bleed under the
  /// status bar.
  final bool safeArea;

  Widget _layered(Widget body) {
    final background = this.background;
    final content = safeArea ? SafeArea(child: body) : body;
    if (background == null) return content;
    return Stack(
      children: [
        Positioned.fill(child: background),
        content,
      ],
    );
  }

  bool get _hasBar => title != null || actions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final title = this.title;
    final bottomBar = this.bottomBar == null
        ? null
        : SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenGutter,
                AppSpacing.sm,
                AppSpacing.screenGutter,
                0,
              ),
              child: this.bottomBar,
            ),
          );

    if (useCupertino) {
      // Difference: Cupertino has no bottom slot, so the bar sits in a Column
      // below the body.
      return cupertino.CupertinoPageScaffold(
        backgroundColor: backgroundColor ?? colors.background,
        navigationBar: _hasBar
            ? cupertino.CupertinoNavigationBar(
                backgroundColor: colors.background,
                border: Border(bottom: BorderSide(color: colors.border)),
                middle: title == null ? null : Text(title),
                trailing: actions.isEmpty
                    ? null
                    : Row(mainAxisSize: MainAxisSize.min, children: actions),
              )
            : null,
        child: Column(
          children: [
            Expanded(child: _layered(body)),
            ?bottomBar,
          ],
        ),
      );
    }

    return material.Scaffold(
      backgroundColor: backgroundColor ?? colors.background,
      appBar: _hasBar
          ? material.AppBar(
              title: title == null ? null : Text(title),
              actions: actions.isEmpty
                  ? null
                  : [...actions, const SizedBox(width: AppSpacing.sm)],
            )
          : null,
      body: _layered(body),
      bottomNavigationBar: bottomBar,
    );
  }
}
