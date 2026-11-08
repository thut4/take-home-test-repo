import 'package:flutter/widgets.dart';

import 'package:jdonuts/design_system/tokens/motion_tokens.dart';

/// Shared-axis (horizontal) page: the new page slides in a short way while
/// fading, the old one slides out the other way. Used between registration
/// steps. Reduce Motion falls back to an instant switch because the route's
/// durations are scaled by the framework.
class SharedAxisPage<T> extends Page<T> {
  const SharedAxisPage({
    required super.key,
    required this.child,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    late final PageRouteBuilder<T> route;
    return route = PageRouteBuilder<T>(
      settings: this,
      transitionDuration: AppMotion.pageTransition,
      reverseTransitionDuration: AppMotion.pageTransition,
      // Read the child from the route's *current* page: when the router
      // updates this page (same key, new child), the route must follow.
      pageBuilder: (context, _, _) => (route.settings as SharedAxisPage).child,
      transitionsBuilder: _sharedAxis,
    );
  }

  static Widget _sharedAxis(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child,
  ) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;
    final incoming = CurvedAnimation(parent: animation, curve: AppMotion.enter);
    final outgoing = CurvedAnimation(parent: secondary, curve: AppMotion.exit);
    return SlideTransition(
      position: Tween(
        begin: const Offset(AppMotion.sharedAxisOffset, 0),
        end: Offset.zero,
      ).animate(incoming),
      child: FadeTransition(
        opacity: incoming,
        child: SlideTransition(
          position: Tween(
            begin: Offset.zero,
            end: const Offset(-AppMotion.sharedAxisOffset, 0),
          ).animate(outgoing),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0).animate(outgoing),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Fade-through page: the old page fades out, the new one fades and scales
/// in. Used where the flow changes context (Welcome, Home after sign-in).
class FadeThroughPage<T> extends Page<T> {
  const FadeThroughPage({
    required super.key,
    required this.child,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    late final PageRouteBuilder<T> route;
    return route = PageRouteBuilder<T>(
      settings: this,
      transitionDuration: AppMotion.slow,
      reverseTransitionDuration: AppMotion.medium,
      // See SharedAxisPage: follow page updates (shell branch switches).
      pageBuilder: (context, _, _) => (route.settings as FadeThroughPage).child,
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.enter,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
