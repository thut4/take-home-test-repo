import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/app.dart';
import 'package:jdonuts/app/bootstrap.dart';
import 'package:jdonuts/core/connectivity/connectivity_service.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/auth_providers.dart';
import 'package:jdonuts/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts/features/auth/data/session_store.dart';

import 'test_database.dart';

/// A clock tests can move forward.
class TestClock {
  TestClock(this.now);

  DateTime now;

  DateTime call() => now;

  void advance(Duration by) => now = now.add(by);
}

class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({this.online = true});

  final bool online;

  @override
  Future<bool> checkOnline() async => online;

  @override
  Stream<bool> watchOnline() => Stream.value(online);
}

/// The whole app on an in-memory seeded database, with a fast fake auth
/// back end, a test clock and no network.
class AppHarness {
  AppHarness._(this.container, this.db, this.clock, this.session);

  final ProviderContainer container;
  final AppDatabase db;
  final TestClock clock;
  final InMemorySessionStore session;

  static const authLatency = Duration(milliseconds: 200);

  /// iPhone 14/15 (6.1").
  static const phoneSize = Size(390, 844);

  /// iPhone SE (4.7"), the smallest phone the brief supports.
  static const smallPhoneSize = Size(375, 667);

  /// iPhone 16 Pro Max (6.9").
  static const largePhoneSize = Size(440, 956);
  static const phonePixelRatio = 3.0;

  static Future<AppHarness> pump(
    WidgetTester tester, {
    String? signedInPhone,
    List<Override> overrides = const [],
    FakeAuthRepository Function(AppDatabase db, SessionStore session)?
    authFactory,
    Size screen = phoneSize,
    double textScale = 1,
  }) async {
    AppNetworkImage.debugNetworkEnabled = false;
    tester.view
      ..physicalSize = screen * phonePixelRatio
      ..devicePixelRatio = phonePixelRatio;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final db = seededDatabase();
    final clock = TestClock(DateTime(2026, 11, 8, 10));
    final session = InMemorySessionStore(signedInPhone);
    final container = await tester.runAsync(
      () => createAppContainer(
        database: db,
        overrides: [
          clockProvider.overrideWithValue(clock.call),
          sessionStoreProvider.overrideWithValue(session),
          connectivityServiceProvider.overrideWithValue(
            FakeConnectivity(online: false),
          ),
          authRepositoryProvider.overrideWith(
            (ref) =>
                authFactory?.call(db, session) ??
                FakeAuthRepository(
                  database: db,
                  sessionStore: session,
                  clock: clock.call,
                  latency: authLatency,
                ),
          ),
          ...overrides,
        ],
      ),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container!,
        child: const JDonutsApp(),
      ),
    );
    await tester.settle();
    return AppHarness._(container, db, clock, session);
  }

  /// Unmounts the app and closes the database so no timers leak.
  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    // Drift's stream queries clean up on a zero-length timer.
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  }
}

extension HarnessTester on WidgetTester {
  /// Advances time in small steps. The app has endless animations, so
  /// pumpAndSettle would never return. Real async work (database, fake
  /// auth delay) is given a moment to finish between frames.
  Future<void> settle([Duration duration = const Duration(seconds: 1)]) async {
    const step = Duration(milliseconds: 100);
    for (var t = Duration.zero; t < duration; t += step) {
      await runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await pump(step);
    }
  }

  Finder field(String key) => find.descendant(
    of: find.byKey(Key(key)),
    matching: find.byType(EditableText),
  );

  /// The CTA's press target (disabled buttons have a null callback).
  bool isContinueEnabled() {
    final pressable = widget<AppPressable>(
      find.ancestor(
        of: find.text('CONTINUE'),
        matching: find.byType(AppPressable),
      ),
    );
    return pressable.onPressed != null;
  }
}

/// The app's router, for jumping straight to a step in tests.
abstract final class GoRouterFinder {
  static GoRouter of(WidgetTester tester) =>
      GoRouter.of(tester.element(find.byType(Navigator).first));
}
