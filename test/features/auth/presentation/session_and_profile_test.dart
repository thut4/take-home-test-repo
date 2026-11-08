import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';
import 'package:jdonuts/features/auth/presentation/controllers/auth_flow_controller.dart';

import '../../../helpers/app_harness.dart';

const _demoPhone = '+959123456789';

/// Jumps straight to a later step with the flow state filled in.
Future<void> _openStep(
  WidgetTester tester,
  AppHarness app,
  String route,
) async {
  app.container.read(authFlowControllerProvider.notifier)
    ..start(AuthMode.register)
    ..setPhoneInput('09254135592');
  await tester.tap(find.byKey(const Key('get-started')));
  await tester.settle();
  unawaited(GoRouterFinder.of(tester).push(route));
  await tester.settle();
}

void main() {
  group('Session', () {
    testWidgets('relaunching while signed in opens Home', (tester) async {
      final app = await AppHarness.pump(tester, signedInPhone: _demoPhone);
      await tester.settle(const Duration(seconds: 2));
      expect(find.text('Hania'), findsOneWidget);
      expect(find.byKey(const Key('get-started')), findsNothing);
      await app.dispose(tester);
    });

    testWidgets('the Reward tab shows the same member record as Home', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester, signedInPhone: _demoPhone);
      await tester.settle(const Duration(seconds: 2));
      expect(
        find.text('500 points left to become Gold Member'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('nav-reward')));
      await tester.settle(const Duration(seconds: 3));
      expect(find.text('680,000'), findsOneWidget);
      expect(find.text('500 pts Remaining to become Gold'), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('relaunching while signed out opens Onboarding', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      expect(find.byKey(const Key('get-started')), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('Log out in Settings returns to Onboarding', (tester) async {
      final app = await AppHarness.pump(tester, signedInPhone: _demoPhone);
      await tester.settle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('nav-settings')));
      await tester.settle();
      await tester.tap(find.byKey(const Key('logout-row')));
      await tester.settle();
      await tester.tap(find.text('Log out').last);
      await tester.settle(const Duration(seconds: 2));
      expect(find.byKey(const Key('get-started')), findsOneWidget);
      expect(await app.session.readPhone(), isNull);
      await app.dispose(tester);
    });
  });

  group('Name step', () {
    testWidgets('rejects digits as soon as they are typed', (tester) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/name');
      await tester.enterText(tester.field('first-name-input'), 'Ye Min 2');
      await tester.settle(const Duration(milliseconds: 300));
      expect(find.text('Use letters and spaces only.'), findsOneWidget);
      expect(tester.isContinueEnabled(), isFalse);
      await app.dispose(tester);
    });

    testWidgets('accepts a Myanmar first name with no last name', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/name');
      await tester.enterText(tester.field('first-name-input'), 'ဇော်ဇော်');
      await tester.settle(const Duration(milliseconds: 300));
      expect(tester.isContinueEnabled(), isTrue);
      await app.dispose(tester);
    });
  });

  group('Date of birth step', () {
    /// Turns wheel [column] of the open date sheet to the row labelled
    /// [option], through the wheel's own controller (the selection callback
    /// fires just as it does for a finger).
    Future<void> turn(WidgetTester tester, int column, String option) async {
      final wheel = tester.widget<ListWheelScrollView>(
        find.descendant(
          of: find.byKey(Key('wheel-$column')),
          matching: find.byType(ListWheelScrollView),
        ),
      );
      final index = switch (column) {
        0 => _months.indexOf(option),
        1 => int.parse(option) - 1,
        _ => _firstYear - int.parse(option),
      };
      (wheel.controller! as FixedExtentScrollController).jumpToItem(index);
      await tester.settle(const Duration(milliseconds: 300));
    }

    Future<void> fill(
      WidgetTester tester,
      String month,
      String day,
      String year,
    ) async {
      await tester.tap(find.byKey(const Key('day-input')));
      await tester.settle();
      await turn(tester, 0, month);
      await turn(tester, 1, day);
      await turn(tester, 2, year);
      await tester.tap(find.byKey(const Key('wheel-done')));
      await tester.settle();
    }

    testWidgets('the year wheel starts at 2013 and offers no later year', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/dob');
      await tester.tap(find.byKey(const Key('year-input')));
      await tester.settle();
      // Fling the year wheel to its top.
      await tester.drag(
        find.byKey(const Key('wheel-2')),
        const Offset(0, 3000),
      );
      await tester.settle();
      final years = find.descendant(
        of: find.byKey(const Key('wheel-2')),
        matching: find.byType(Text),
      );
      expect(
        years.evaluate().map((e) => (e.widget as Text).data),
        containsAllInOrder(['2013', '2012']),
      );
      expect(find.text('2014'), findsNothing);
      await app.dispose(tester);
    });

    testWidgets('the sheet warns about 31 April before Done is tapped', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/dob');
      await tester.tap(find.byKey(const Key('month-input')));
      await tester.settle();
      await turn(tester, 0, 'April');
      await turn(tester, 1, '31');
      expect(find.textContaining("That date doesn't exist"), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('rejects 31 April', (tester) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/dob');
      await fill(tester, 'April', '31', '1990');
      expect(find.textContaining("That date doesn't exist"), findsOneWidget);
      expect(tester.isContinueEnabled(), isFalse);
      await app.dispose(tester);
    });

    testWidgets('rejects someone younger than 13', (tester) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/dob');
      // 31 December 2013: the newest year offered, but still 12 today.
      await fill(tester, 'December', '31', '2013');
      expect(find.textContaining('at least 13'), findsOneWidget);
      expect(tester.isContinueEnabled(), isFalse);
      await app.dispose(tester);
    });

    testWidgets('enables Continue for a valid date', (tester) async {
      final app = await AppHarness.pump(tester);
      await _openStep(tester, app, '/auth/dob');
      await fill(tester, 'May', '1', '1980');
      expect(tester.isContinueEnabled(), isTrue);
      await app.dispose(tester);
    });
  });
}

const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', //
  'August', 'September', 'October', 'November', 'December',
];

/// The harness clock is 8 November 2026, so the year wheel starts at 2013.
const _firstYear = 2013;
