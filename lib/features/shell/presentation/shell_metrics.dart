import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';

// Space tab content leaves at the bottom so it can scroll clear of the
// floating navigation bar.
double bottomNavInset(BuildContext context) =>
    AppSize.bottomNavHeight +
    MediaQuery.paddingOf(context).bottom +
    AppSpacing.lg;
