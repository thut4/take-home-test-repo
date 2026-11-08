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

  /// Relative to [home], so the page stays in the Home tab.
  static const sectionPattern = 'section/:id';

  static String product(String id) => '/product/$id';
  static String section(String id) => '$home/section/$id';

  /// Screens reachable without a session.
  static bool isAuthFlow(String location) =>
      location == onboarding || location.startsWith('/auth/');
}
