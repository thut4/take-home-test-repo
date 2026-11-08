import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:material_ui/material_ui.dart' as material;

// Page for go_router `pageBuilder` (or any `Navigator.pages`).
//
// ```dart
// GoRoute(
//   path: '/',
//   pageBuilder: (context, state) =>
//       buildAdaptivePage(key: state.pageKey, child: const HomeScreen()),
// )
// ```
Page<T> buildAdaptivePage<T>({
  required LocalKey key,
  required Widget child,
  String? name,
  Object? arguments,
  String? restorationId,
  String? title,
  bool fullscreenDialog = false,
}) {
  if (useCupertino) {
    return cupertino.CupertinoPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      title: title,
      fullscreenDialog: fullscreenDialog,
      child: child,
    );
  }
  // MaterialPage uses the platform's transition, so iOS keeps the native
  // slide and swipe-back under RendererPolicy.brand.
  return material.MaterialPage<T>(
    key: key,
    name: name,
    arguments: arguments,
    restorationId: restorationId,
    fullscreenDialog: fullscreenDialog,
    child: child,
  );
}
