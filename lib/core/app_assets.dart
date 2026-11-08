abstract final class AppAsset {
  static const _images = 'assets/images';
  static const _svg = '$_images/svg';
  static const _products = '$_images/products';
  static const _brand = '$_images/brand';

  // Social sign-in icons (SVG).
  static const google = '$_svg/google.svg';
  static const apple = '$_svg/apple-filled.svg';
  static const facebook = '$_svg/facebook.svg';

  // Donut artwork on Onboarding and Welcome.
  static const donutPinkSprinkle = '$_products/pink_sprinkle.png';
  static const donutBlueberry = '$_products/blueberry.png';
  static const donutStrawberryChoc = '$_products/strawberry_choc.png';
  static const donutChocSprinkle = '$_products/choc_sprinkle.png';

  // Brand.
  static const memberAvatar = '$_brand/member_avatar.png';

  /// First-launch data for the local database.
  static const seed = 'assets/seed/seed.json';

  /// The bundled copy of a catalogue image referenced by data, such as
  /// `products/coconut.png` (the same path the server serves it under).
  static String catalogImage(String path) => '$_images/$path';
}
