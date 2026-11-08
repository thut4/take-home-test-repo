import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

/// Overflow errors are reported as exceptions, so every screen below fails
/// the test if anything clips at the size and text scale under test.
void main() {
  const maxTextScale = 1.3;

  for (final (name, size) in [
    ('4.7"', AppHarness.smallPhoneSize),
    ('6.9"', AppHarness.largePhoneSize),
  ]) {
    testWidgets('signed-out screens fit a $name phone at text scale 1.3', (
      tester,
    ) async {
      final app = await AppHarness.pump(
        tester,
        screen: size,
        textScale: maxTextScale,
      );
      await tester.settle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('get-started')));
      await tester.settle();
      expect(find.byKey(const Key('phone-input')), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('Home, Product detail and Rewards fit a $name phone at text '
        'scale 1.3', (tester) async {
      final app = await AppHarness.pump(
        tester,
        signedInPhone: '+959123456789',
        screen: size,
        textScale: maxTextScale,
      );
      await tester.settle(const Duration(seconds: 2));
      final tile = find.byKey(const Key('product-tile-order_again-p_caramel'));
      await tester.scrollUntilVisible(
        tile,
        200,
        scrollable: find
            .descendant(
              of: find.byKey(const Key('home-scroll')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.settle();
      await tester.tap(tile);
      await tester.settle();
      expect(find.text('JD022127'), findsOneWidget);
      GoRouterFinder.of(tester).pop();
      await tester.settle();

      await tester.tap(find.byKey(const Key('nav-reward')));
      await tester.settle(const Duration(seconds: 3));
      await tester.drag(
        find.byKey(const Key('rewards-scroll')),
        const Offset(0, -800),
      );
      await tester.settle();
      await tester.tap(find.byKey(const Key('nav-settings')));
      await tester.settle();
      await app.dispose(tester);
    });
  }
}
