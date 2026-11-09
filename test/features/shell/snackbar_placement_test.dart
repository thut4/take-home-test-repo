import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/shell/presentation/app_shell.dart';
import 'package:material_ui/material_ui.dart' as material;

import '../../helpers/app_harness.dart';

void main() {
  for (final (name, safeBottom) in [
    ('no home indicator', 0.0),
    ('a home indicator', 34.0),
  ]) {
    testWidgets('a snackbar on a tab clears the bottom bar with $name', (
      tester,
    ) async {
      final inset = FakeViewPadding(
        bottom: safeBottom * AppHarness.phonePixelRatio,
      );
      tester.view
        ..padding = inset
        ..viewPadding = inset;
      final app = await AppHarness.pump(
        tester,
        signedInPhone: '+959123456789',
      );
      await tester.settle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('nav-reward')));
      await tester.settle(const Duration(seconds: 3));

      showAppSnackbar(
        tester.element(find.byKey(const Key('rewards-scroll'))),
        'Hello',
      );
      await tester.settle();

      // The Material is the visible surface; SnackBar's own box includes
      // its transparent margin.
      final snackbar = tester.getRect(
        find
            .descendant(
              of: find.byType(material.SnackBar),
              matching: find.byType(material.Material),
            )
            .first,
      );
      final bar = tester.getRect(find.byType(BottomNavBar));
      expect(snackbar.bottom, lessThanOrEqualTo(bar.top));

      await app.dispose(tester);
    });
  }
}
