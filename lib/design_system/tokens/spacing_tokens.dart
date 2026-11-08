/// 4-point spacing grid.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal padding for page content (registration, Rewards).
  static const double screenGutter = 24;

  /// Horizontal padding on Home, where lists bleed to the edge.
  static const double listGutter = lg;
}

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 6;
  static const double md = 10;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double pill = 999;
}

/// Fixed component dimensions.
abstract final class AppSize {
  /// Minimum tappable size (Material guidance; also satisfies Apple's 44pt).
  static const double minTouchTarget = 48;
  static const double buttonHeight = 52;
  static const double inputHeight = 56;
  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 36;
  static const double backButton = 36;
  static const double stepRing = 30;
  static const double otpBox = 48;
  static const double avatar = 52;
  static const double bottomNavHeight = 72;
  static const double productTileWidth = 150;
  static const double productTileImage = 150;
  static const double seasonalTileWidth = 220;
  static const double seasonalTileHeight = 140;
  static const double shopCardWidth = 240;
  static const double bannerHeight = 156;
  static const double contentMaxWidth = 560;
}
