/// Every route path in one place.
abstract final class Routes {
  static const onboarding = '/onboarding';
  static const phone = '/auth/phone';
  static const otp = '/auth/otp';
  static const name = '/auth/name';
  static const dateOfBirth = '/auth/dob';
  static const welcome = '/welcome';
  static const home = '/home';
  static const rewards = '/rewards';
  static const order = '/order';
  static const wallet = '/wallet';
  static const settings = '/settings';
  static const productPattern = '/product/:id';

  static String product(String id) => '/product/$id';

  /// Screens reachable without a session.
  static bool isAuthFlow(String location) =>
      location == onboarding || location.startsWith('/auth/');
}
