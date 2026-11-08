import 'package:flutter/animation.dart';

/// Every animation duration and curve in the app. Widgets never write a
/// literal Duration or Curve; they pick one of these and pass it through
/// `context.motion(...)`, which shortens it to zero under Reduce Motion.
abstract final class AppMotion {
  // Generic building blocks.
  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve spring = Curves.elasticOut;

  // Press feedback.
  static const Duration press = Duration(milliseconds: 110);
  static const double pressedScale = 0.95;

  // Page transitions between registration steps (shared axis).
  static const Duration pageTransition = Duration(milliseconds: 380);
  static const double sharedAxisOffset = 0.18;

  // Staggered entrances (onboarding, welcome, home sections, rewards cards).
  static const Duration staggerStep = Duration(milliseconds: 80);
  static const Duration entrance = Duration(milliseconds: 520);
  static const double entranceOffset = 24;

  // Onboarding donut circles drifting in, and their idle float.
  static const Duration drift = Duration(milliseconds: 1100);
  static const Duration idleFloat = Duration(milliseconds: 3200);
  static const double idleFloatDistance = 6;

  // Registration progress ring.
  static const Duration ringProgress = Duration(milliseconds: 650);
  static const Duration ringMorph = Duration(milliseconds: 420);

  // Inputs.
  static const Duration fieldFocus = Duration(milliseconds: 180);
  static const Duration shake = Duration(milliseconds: 460);
  static const double shakeDistance = 10;
  static const int shakeCycles = 3;

  // Continue button morphing into its loading state.
  static const Duration buttonMorph = Duration(milliseconds: 260);

  // Home.
  static const Duration shimmer = Duration(milliseconds: 1300);
  static const Duration carouselInterval = Duration(seconds: 4);
  static const Duration carouselSlide = Duration(milliseconds: 520);
  static const Duration banner = Duration(milliseconds: 300);

  // Product detail.
  static const Duration heroFlight = Duration(milliseconds: 420);
  static const Duration quantityChange = Duration(milliseconds: 220);
  static const Duration cartFeedback = Duration(milliseconds: 1400);

  // Rewards.
  static const Duration pointsRing = Duration(milliseconds: 1500);
  static const Duration tierStep = Duration(milliseconds: 360);
  static const Duration tierLineFill = Duration(milliseconds: 700);
  static const Duration tabSwitch = Duration(milliseconds: 320);
  static const Duration challengeArt = Duration(milliseconds: 900);
  static const Duration attentionPulse = Duration(milliseconds: 1100);
  static const Duration badgePop = Duration(milliseconds: 520);
  static const Duration badgeDelay = Duration(milliseconds: 450);
  static const double attentionScale = 1.06;

  // Bottom navigation pill.
  static const Duration navPill = Duration(milliseconds: 340);
}
