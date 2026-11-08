import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:material_ui/material_ui.dart' as material;

// Shows a two-action confirmation dialog.
//
// Returns true when the user confirms, false on cancel or dismissal.
// [isDestructive] marks the confirm action as destructive (shown in the
// error colour).
Future<bool> showAdaptiveConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'OK',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) async {
  final Widget? content = message == null ? null : Text(message);

  if (useCupertino) {
    // Difference: iOS alerts are not dismissed by tapping outside; Material
    // dialogs are (returning false).
    final result = await cupertino.showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => cupertino.CupertinoAlertDialog(
        title: Text(title),
        content: content,
        actions: [
          cupertino.CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          cupertino.CupertinoDialogAction(
            isDefaultAction: !isDestructive,
            isDestructiveAction: isDestructive,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  final result = await material.showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final colors = dialogContext.appTheme.colors;
      return material.AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          material.TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancelLabel),
          ),
          material.TextButton(
            style: isDestructive
                ? material.TextButton.styleFrom(foregroundColor: colors.error)
                : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
