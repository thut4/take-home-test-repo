import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jdonuts/app/app.dart';
import 'package:jdonuts/app/bootstrap.dart';
import 'package:jdonuts/core/connectivity/connectivity_service.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/auth_providers.dart';
import 'package:jdonuts/features/auth/data/session_store.dart';

/// Offline, so the run never depends on a server: everything comes from the
/// seeded database and bundled images, exactly as in airplane mode.
class _Offline implements ConnectivityService {
  @override
  Future<bool> checkOnline() async => false;

  @override
  Stream<bool> watchOnline() => Stream.value(false);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pump(const Duration(milliseconds: 900));
    await binding.convertFlutterSurfaceToImage();
    await tester.pump();
    await binding.takeScreenshot(name);
  }

  testWidgets('a new customer registers, lands on Home and opens a product', (
    tester,
  ) async {
    AppNetworkImage.debugNetworkEnabled = false;
    final container = await createAppContainer(
      database: AppDatabase(NativeDatabase.memory(), seeder: bundledSeeder()),
      overrides: [
        sessionStoreProvider.overrideWithValue(InMemorySessionStore()),
        connectivityServiceProvider.overrideWithValue(_Offline()),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const JDonutsApp(),
      ),
    );

    // Onboarding → phone.
    await tester.pumpUntil(find.byKey(const Key('get-started')));
    await shot(tester, '01-onboarding');
    await tester.tap(find.byKey(const Key('get-started')));
    await tester.pumpUntil(find.byKey(const Key('phone-input')));
    await tester.enterText(_field('phone-input'), '09254135592');
    await tester.pump();
    await shot(tester, '02-phone');
    await tester.tap(find.text('CONTINUE'));

    // OTP (the fake call takes about a second).
    await tester.pumpUntil(find.byKey(const Key('otp-input')));
    await shot(tester, '03-otp');
    await tester.enterText(_field('otp-input'), '123456');

    // Name.
    await tester.pumpUntil(find.byKey(const Key('first-name-input')));
    await tester.enterText(_field('first-name-input'), 'Ye Min');
    await tester.enterText(_field('last-name-input'), 'Phyoe Win');
    await tester.pump();
    await shot(tester, '04-name');
    await tester.tap(find.text('CONTINUE'));

    // Date of birth: one sheet with month, day and year wheels.
    await tester.pumpUntil(find.byKey(const Key('month-input')));
    await tester.tap(find.byKey(const Key('month-input')));
    await tester.pumpUntil(find.byKey(const Key('wheel-done')));
    await tester.turnWheel(0, 4); // May
    await tester.turnWheel(1, 0); // 1
    await tester.turnWheel(2, DateTime.now().year - 13 - 1990); // 1990
    await shot(tester, '05a-date-wheels');
    await tester.tap(find.byKey(const Key('wheel-done')));
    await tester.pumpFor(const Duration(milliseconds: 600));
    await shot(tester, '05-date-of-birth');
    await tester.tap(find.text('CONTINUE'));

    // Welcome → Home.
    await tester.pumpUntil(find.byKey(const Key('lets-explore')));
    await tester.pumpFor(const Duration(seconds: 2));
    await shot(tester, '06-welcome');
    await tester.tap(find.byKey(const Key('lets-explore')));
    await tester.pumpUntil(find.text('Ye Min Phyoe Win'));
    await shot(tester, '07-home');

    // Product detail for Coconut Donut, from the Popular section.
    final tile = find.byKey(const Key('product-tile-popular-p_coconut'));
    await tester.scrollUntilVisible(
      tile,
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const Key('home-scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpFor(const Duration(milliseconds: 400));
    await shot(tester, '08-home-scrolled');
    await tester.tap(tile);
    await tester.pumpUntil(find.text('JD022123'));
    expect(find.text('Coconut Donut'), findsOneWidget);
    expect(find.text('3,200 MMK'), findsNWidgets(2)); // Price and total.
    await tester.tap(find.byKey(const Key('quantity-increase')));
    await tester.pumpFor(const Duration(milliseconds: 400));
    expect(find.text('6,400 MMK'), findsOneWidget);
    await shot(tester, '09-product-detail');

    // Rewards, for the screenshots.
    await tester.pageBack();
    await tester.pumpFor(const Duration(milliseconds: 600));
    await tester.tap(find.byKey(const Key('nav-reward')));
    await tester.pumpFor(const Duration(seconds: 3));
    await shot(tester, '10-rewards');
    expect(find.byKey(const Key('total-points')), findsOneWidget);
    expect(find.text('680,000'), findsOneWidget);
    await tester.tap(find.byKey(const Key('reward-tab-gift')));
    await tester.pumpFor(const Duration(seconds: 1));
    await shot(tester, '11-rewards-gift');
  });
}

Finder _field(String key) => find.descendant(
  of: find.byKey(Key(key)),
  matching: find.byType(EditableText),
);

extension on WidgetTester {
  /// Turns wheel [column] of the open date sheet to item [index] through
  /// the wheel's own controller, then waits for it to settle.
  Future<void> turnWheel(int column, int index) async {
    final wheel = widget<ListWheelScrollView>(
      find.descendant(
        of: find.byKey(Key('wheel-$column')),
        matching: find.byType(ListWheelScrollView),
      ),
    );
    // Frames are pumped below, so the animation isn't awaited directly.
    (wheel.controller! as FixedExtentScrollController).animateToItem(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    await pumpFor(const Duration(milliseconds: 800));
  }

  /// Pumps frames until [finder] matches. The app has endless animations
  /// (shimmer, carousel), so pumpAndSettle would never return.
  Future<void> pumpUntil(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (finder.evaluate().isEmpty) {
      if (DateTime.now().isAfter(end)) {
        throw TimeoutException('Not found: $finder', timeout);
      }
      await pump(const Duration(milliseconds: 100));
    }
    await pump(const Duration(milliseconds: 300));
  }

  Future<void> pumpFor(Duration duration) async {
    final end = DateTime.now().add(duration);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 50));
    }
  }
}
