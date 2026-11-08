import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/app/router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';

void main() {
  final account = UserAccount(
    phone: '+959123456789',
    firstName: 'Hania',
    dateOfBirth: DateTime(1995, 3, 14),
  );

  group('authRedirect', () {
    test('sends a signed-out user to Onboarding from any app screen', () {
      expect(authRedirect(const SignedOut(), Routes.home), Routes.onboarding);
      expect(
        authRedirect(const SignedOut(), Routes.product('p_coconut')),
        Routes.onboarding,
      );
      expect(
        authRedirect(const SignedOut(), Routes.section('popular')),
        Routes.onboarding,
      );
      expect(
        authRedirect(const SignedOut(), Routes.welcome),
        Routes.onboarding,
      );
    });

    test('lets a signed-out user through the auth steps', () {
      expect(authRedirect(const SignedOut(), Routes.onboarding), isNull);
      expect(authRedirect(const SignedOut(), Routes.otp), isNull);
    });

    test('sends a returning user from the auth steps to Home', () {
      expect(authRedirect(SignedIn(account), Routes.otp), Routes.home);
    });

    test('sends a brand-new account to Welcome first', () {
      expect(
        authRedirect(SignedIn(account, isNewAccount: true), Routes.dateOfBirth),
        Routes.welcome,
      );
    });

    test('leaves a signed-in user on app screens', () {
      expect(authRedirect(SignedIn(account), Routes.rewards), isNull);
    });
  });
}
