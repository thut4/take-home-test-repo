import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:material_ui/material_ui.dart' as material;

// One row in a list.
class AdaptiveListTile extends StatelessWidget {
  const AdaptiveListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

    if (useCupertino) {
      // Difference: tappable Cupertino rows with no trailing widget get the
      // iOS disclosure chevron.
      return cupertino.CupertinoListTile(
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        leading: leading,
        trailing:
            trailing ??
            (onTap != null ? const cupertino.CupertinoListTileChevron() : null),
        onTap: onTap,
      );
    }
    return material.ListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
