import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/data/fake_auth_repository.dart';

import '../../../helpers/app_harness.dart';

/// Counts back-end calls so a double tap can be proven to send one request.
class _CountingAuth extends FakeAuthRepository {
  _CountingAuth({
    required super.database,
    required super.sessionStore,
    super.latency,
  });

  int sendOtpCalls = 0;

  @override
  Future<Result<Unit>> sendOtp(String phone) {
    sendOtpCalls++;
    return super.sendOtp(phone);
  }
}

Future<void> _toPhoneStep(WidgetTester tester, {bool logIn = false}) async {
  if (logIn) {
    await tester.tapOnText(find.textRange.ofSubstring('Log in'));
  } else {
    await tester.tap(find.byKey(const Key('get-started')));
  }
  await tester.settle();
}

Future<void> _toOtpStep(WidgetTester tester, String phone) async {
  await _toPhoneStep(tester);
  await tester.enterText(tester.field('phone-input'), phone);
  await tester.settle(const Duration(milliseconds: 200));
  await tester.tap(find.text('CONTINUE'));
  await tester.settle(const Duration(seconds: 2));
}

void main() {
  group('Phone step', () {
    testWidgets('keeps Continue disabled for an invalid number', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _toPhoneStep(tester);

      await tester.enterText(tester.field('phone-input'), '0925');
      await tester.settle(const Duration(milliseconds: 200));
      expect(tester.isContinueEnabled(), isFalse);

      await tester.enterText(tester.field('phone-input'), '09 254 135 592');
      await tester.settle(const Duration(milliseconds: 200));
      expect(tester.isContinueEnabled(), isTrue);
      await app.dispose(tester);
    });

    testWidgets('does not take more than 11 digits', (tester) async {
      final app = await AppHarness.pump(tester);
      await _toPhoneStep(tester);
      final field = tester.field('phone-input');
      String text() => tester.widget<EditableText>(field).controller.text;

      await tester.enterText(field, '09972532188');
      await tester.pump();
      expect(text(), '09972532188');

      await tester.enterText(field, '099725321881');
      await tester.pump();
      expect(text(), '09972532188');
      await app.dispose(tester);
    });

    testWidgets('accepts a plain 11-digit number', (tester) async {
      final app = await AppHarness.pump(tester);
      await _toPhoneStep(tester);

      await tester.enterText(tester.field('phone-input'), '09972532188');
      await tester.settle(const Duration(milliseconds: 200));
      expect(tester.isContinueEnabled(), isTrue);
      await app.dispose(tester);
    });

    testWidgets('shows the rule only after the field loses focus', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _toPhoneStep(tester);
      await tester.enterText(tester.field('phone-input'), '0925');
      await tester.settle(const Duration(milliseconds: 200));
      expect(
        find.textContaining('Enter a Myanmar mobile number'),
        findsNothing,
      );

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.settle(const Duration(milliseconds: 300));
      expect(
        find.textContaining('Enter a Myanmar mobile number'),
        findsOneWidget,
      );
      await app.dispose(tester);
    });

    testWidgets('log in with an unregistered number offers to register', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _toPhoneStep(tester, logIn: true);
      await tester.enterText(tester.field('phone-input'), '09254135592');
      await tester.settle(const Duration(milliseconds: 200));
      await tester.tap(find.text('CONTINUE'));
      await tester.settle(const Duration(seconds: 2));

      expect(
        find.textContaining("This number isn't registered yet."),
        findsOneWidget,
      );
      expect(find.textContaining('Create an account'), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('a double tap on Continue sends one request', (tester) async {
      late _CountingAuth auth;
      final app = await AppHarness.pump(
        tester,
        authFactory: (db, session) => auth = _CountingAuth(
          database: db,
          sessionStore: session,
          latency: AppHarness.authLatency,
        ),
      );
      await _toPhoneStep(tester);
      await tester.enterText(tester.field('phone-input'), '09254135592');
      await tester.settle(const Duration(milliseconds: 200));
      final cta = find.byType(AppCtaButton);
      await tester.tap(cta);
      await tester.pump(const Duration(milliseconds: 20));
      await tester.tap(cta, warnIfMissed: false);
      await tester.settle(const Duration(seconds: 2));

      expect(auth.sendOtpCalls, 1);
      await app.dispose(tester);
    });
  });

  group('OTP step', () {
    testWidgets('a wrong code clears the boxes and says how many tries are '
        'left', (tester) async {
      final app = await AppHarness.pump(tester);
      await _toOtpStep(tester, '09254135592');

      await tester.enterText(tester.field('otp-input'), '111111');
      await tester.settle();

      expect(find.textContaining('2 tries left'), findsOneWidget);
      expect(find.text('1'), findsNothing);
      await app.dispose(tester);
    });

    testWidgets('three wrong codes lock entry until Resend', (tester) async {
      final app = await AppHarness.pump(tester);
      await _toOtpStep(tester, '09254135592');
      for (var i = 0; i < 3; i++) {
        await tester.enterText(tester.field('otp-input'), '11111$i');
        await tester.settle();
      }
      expect(find.textContaining('Too many wrong codes'), findsOneWidget);
      expect(
        tester.widget<EditableText>(tester.field('otp-input')).readOnly ||
            !tester
                .widget<EditableText>(tester.field('otp-input'))
                .focusNode
                .canRequestFocus,
        isTrue,
      );

      app.clock.advance(const Duration(minutes: 5));
      await tester.settle(const Duration(seconds: 2));
      await tester.tap(find.byKey(const Key('otp-resend')));
      await tester.settle();
      expect(find.textContaining("We've sent a new code"), findsOneWidget);
      expect(find.textContaining('5:00'), findsOneWidget);
      await app.dispose(tester);
    });

    testWidgets('the resend countdown starts at 5:00 and ticks down', (
      tester,
    ) async {
      final app = await AppHarness.pump(tester);
      await _toOtpStep(tester, '09254135592');
      expect(find.textContaining('5:00'), findsOneWidget);
      app.clock.advance(const Duration(seconds: 2));
      await tester.settle();
      expect(find.textContaining('4:58'), findsOneWidget);
      await app.dispose(tester);
    });
  });
}
