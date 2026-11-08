import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Placeholder for the Order and Wallet tabs.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AdaptiveScaffold(
      backgroundColor: context.appTheme.colors.surfaceMuted,
      body: AppEntrance(
        child: AppEmptyView(title: l10n.comingSoonTitle(title), message: ''),
      ),
    );
  }
}
