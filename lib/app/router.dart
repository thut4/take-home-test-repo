import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';
import 'package:jdonuts/features/auth/presentation/screens/date_of_birth_screen.dart';
import 'package:jdonuts/features/auth/presentation/screens/name_screen.dart';
import 'package:jdonuts/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:jdonuts/features/auth/presentation/screens/otp_screen.dart';
import 'package:jdonuts/features/auth/presentation/screens/phone_screen.dart';
import 'package:jdonuts/features/auth/presentation/screens/welcome_screen.dart';
import 'package:jdonuts/features/home/presentation/home_screen.dart';
import 'package:jdonuts/features/home/presentation/section_screen.dart';
import 'package:jdonuts/features/product/presentation/product_detail_screen.dart';
import 'package:jdonuts/features/rewards/presentation/rewards_screen.dart';
import 'package:jdonuts/features/settings/presentation/settings_screen.dart';
import 'package:jdonuts/features/shell/presentation/app_shell.dart';
import 'package:jdonuts/features/shell/presentation/coming_soon_screen.dart';
import 'package:jdonuts/l10n/l10n.dart';

/// Where the auth guard sends [location] for the given session; null keeps
/// it. Signed out: only Onboarding and the auth steps. Signed in: never the
/// auth steps; a brand-new account goes to Welcome first.
String? authRedirect(SessionState session, String location) {
  final inAuthFlow = Routes.isAuthFlow(location);
  return switch (session) {
    SignedOut() when !inAuthFlow => Routes.onboarding,
    SignedIn(isNewAccount: true) when inAuthFlow => Routes.welcome,
    SignedIn() when inAuthFlow => Routes.home,
    _ => null,
  };
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier<SessionState>(
    ref.read(sessionControllerProvider),
  );
  ref.listen(sessionControllerProvider, (_, next) => session.value = next);
  final router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.home,
    refreshListenable: session,
    redirect: (context, state) =>
        authRedirect(session.value, state.matchedLocation),
    routes: [..._authRoutes, _shellRoute, _productRoute],
  );
  ref.onDispose(() {
    router.dispose();
    session.dispose();
  });
  return router;
});

GoRoute _fade(String path, Widget child) => GoRoute(
  path: path,
  pageBuilder: (context, state) =>
      FadeThroughPage<void>(key: state.pageKey, child: child),
);

GoRoute _step(String path, Widget child) => GoRoute(
  path: path,
  pageBuilder: (context, state) =>
      SharedAxisPage<void>(key: state.pageKey, child: child),
);

final _authRoutes = <RouteBase>[
  _fade(Routes.onboarding, const OnboardingScreen()),
  _step(Routes.phone, const PhoneScreen()),
  _step(Routes.otp, const OtpScreen()),
  _step(Routes.name, const NameScreen()),
  _step(Routes.dateOfBirth, const DateOfBirthScreen()),
  _fade(Routes.welcome, const WelcomeScreen()),
];

GoRoute _tab(String path, Widget child, {List<RouteBase> routes = const []}) =>
    GoRoute(
      path: path,
      pageBuilder: (context, state) =>
          NoTransitionPage<void>(key: state.pageKey, child: child),
      routes: routes,
    );

final _shellRoute = StatefulShellRoute.indexedStack(
  pageBuilder: (context, state, shell) => FadeThroughPage<void>(
    key: state.pageKey,
    child: AppShell(navigationShell: shell),
  ),
  branches: [
    StatefulShellBranch(
      routes: [
        _tab(Routes.home, const HomeScreen(), routes: [_sectionRoute]),
      ],
    ),
    StatefulShellBranch(routes: [_tab(Routes.rewards, const RewardsScreen())]),
    StatefulShellBranch(
      routes: [_tab(Routes.order, const _ComingSoon(ShellTab.order))],
    ),
    StatefulShellBranch(
      routes: [_tab(Routes.wallet, const _ComingSoon(ShellTab.wallet))],
    ),
    StatefulShellBranch(
      routes: [_tab(Routes.settings, const SettingsScreen())],
    ),
  ],
);

final _sectionRoute = GoRoute(
  path: Routes.sectionPattern,
  pageBuilder: (context, state) => buildAdaptivePage<void>(
    key: state.pageKey,
    child: SectionScreen(sectionId: state.pathParameters['id']!),
  ),
);

final _productRoute = GoRoute(
  path: Routes.productPattern,
  parentNavigatorKey: _rootKey,
  pageBuilder: (context, state) => buildAdaptivePage<void>(
    key: state.pageKey,
    child: ProductDetailScreen(
      productId: state.pathParameters['id']!,
      heroOrigin: state.uri.queryParameters['from'],
    ),
  ),
);

class _ComingSoon extends StatelessWidget {
  const _ComingSoon(this.tab);

  final ShellTab tab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ComingSoonScreen(
      title: tab == ShellTab.order ? l10n.navOrder : l10n.navWallet,
    );
  }
}
