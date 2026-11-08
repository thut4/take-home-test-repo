import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:material_ui/material_ui.dart' as material;

/// On/off switch. Disabled when [onChanged] is null.
class AdaptiveSwitch extends StatelessWidget {
  const AdaptiveSwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    if (useCupertino) {
      return cupertino.CupertinoSwitch(
        value: value,
        activeTrackColor: colors.primary,
        onChanged: onChanged,
      );
    }
    return material.Switch(
      value: value,
      activeTrackColor: colors.primary,
      activeThumbColor: colors.onPrimary,
      onChanged: onChanged,
    );
  }
}
