import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/home/presentation/widgets/product_tiles.dart';

import '../../../helpers/app_harness.dart';

const _phone = '+959123456789';

Finder _seeAll(String section) => find.byWidgetPredicate(
  (widget) =>
      widget is AppPressable && widget.semanticLabel == 'See all $section',
);

Finder _tile(String origin, String product) =>
    find.byKey(Key('product-tile-$origin-$product'));

Future<void> _openSeeAll(WidgetTester tester, String section) async {
  await tester.scrollUntilVisible(
    _seeAll(section),
    200,
    scrollable: find
        .descendant(
          of: find.byKey(const Key('home-scroll')),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.settle();
  await tester.tap(_seeAll(section));
  await tester.settle();
}

Future<AppHarness> _pumpHome(
  WidgetTester tester, {
  Size screen = AppHarness.phoneSize,
  double textScale = 1,
}) async {
  final app = await AppHarness.pump(
    tester,
    signedInPhone: _phone,
    screen: screen,
    textScale: textScale,
  );
  await tester.settle(const Duration(seconds: 2));
  return app;
}

void main() {
  testWidgets('See all keeps the bottom bar and follows the Product flow', (
    tester,
  ) async {
    final app = await _pumpHome(tester);
    await _openSeeAll(tester, 'Popular');

    expect(find.text('Popular 🔥'), findsOneWidget);
    expect(find.byKey(const Key('nav-home')), findsOneWidget);
    for (final product in [
      'p_strawberry_choc',
      'p_dalgona',
      'p_coconut',
      'p_pink_sprinkle',
      'p_iced_americano',
    ]) {
      expect(_tile('all-popular', product), findsOneWidget);
    }

    await tester.tap(_tile('all-popular', 'p_coconut'));
    await tester.pump();
    final tag = productHeroTag('all-popular', 'p_coconut');
    expect(
      find.byWidgetPredicate((w) => w is Hero && w.tag == tag),
      findsWidgets,
    );
    await tester.settle();
    expect(find.text('JD022123'), findsOneWidget);
    expect(find.byKey(const Key('nav-home')), findsNothing);

    GoRouterFinder.of(tester).pop();
    await tester.settle();
    expect(_tile('all-popular', 'p_coconut'), findsOneWidget);
    expect(find.byKey(const Key('nav-home')), findsOneWidget);

    await tester.tap(find.byType(AppBackButton));
    await tester.settle();
    expect(_tile('all-popular', 'p_coconut'), findsNothing);
    expect(_tile('popular', 'p_coconut'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('the Home tab returns to Home from See all', (tester) async {
    final app = await _pumpHome(tester);
    await _openSeeAll(tester, 'Popular');
    await tester.tap(find.byKey(const Key('nav-home')));
    await tester.settle();
    expect(_tile('all-popular', 'p_coconut'), findsNothing);
    expect(_tile('popular', 'p_coconut'), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('card sections use two columns', (tester) async {
    final app = await _pumpHome(tester);
    await _openSeeAll(tester, 'Order again');

    final first = tester.getRect(_tile('all-order_again', 'p_caramel'));
    final second = tester.getRect(_tile('all-order_again', 'p_iced_latte'));
    final third = tester.getRect(_tile('all-order_again', 'p_classic_glazed'));
    expect(second.top, first.top);
    expect(second.left, greaterThan(first.right));
    expect(third.top, greaterThan(first.bottom));
    expect(third.left, first.left);
    await app.dispose(tester);
  });

  testWidgets('wide sections stack full-width tiles', (tester) async {
    final app = await _pumpHome(tester);
    await _openSeeAll(tester, 'Seasonal specials');

    final first = tester.getRect(_tile('all-seasonal', 'p_mistletoe_box'));
    final second = tester.getRect(_tile('all-seasonal', 'p_christmas_box'));
    expect(first.left, AppSpacing.listGutter);
    expect(first.width, AppHarness.phoneSize.width - AppSpacing.listGutter * 2);
    expect(second.top, greaterThan(first.bottom));
    await app.dispose(tester);
  });

  testWidgets('an unknown section shows a not-available message', (
    tester,
  ) async {
    final app = await _pumpHome(tester);
    GoRouterFinder.of(tester).go(Routes.section('gone'));
    await tester.settle();
    expect(find.text("This section isn't available any more."), findsOneWidget);
    await app.dispose(tester);
  });

  testWidgets('an empty section has no See all button', (tester) async {
    final app = await _pumpHome(tester);
    await tester.runAsync(
      () => (app.db.delete(
        app.db.sectionProducts,
      )..where((row) => row.sectionId.equals('popular'))).go(),
    );
    await tester.settle();
    expect(_seeAll('Popular'), findsNothing);
    await app.dispose(tester);
  });

  for (final (name, size) in [
    ('4.7"', AppHarness.smallPhoneSize),
    ('6.9"', AppHarness.largePhoneSize),
  ]) {
    testWidgets('See all fits a $name phone at text scale 1.3', (tester) async {
      final app = await _pumpHome(tester, screen: size, textScale: 1.3);
      await _openSeeAll(tester, 'Popular');
      await tester.drag(
        find.byKey(const Key('section-scroll')),
        const Offset(0, -800),
      );
      await tester.settle();
      expect(tester.takeException(), isNull);
      await app.dispose(tester);
    });
  }
}
