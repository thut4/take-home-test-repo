import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jdonuts/features/product/domain/product.dart';

part 'home_content.freezed.dart';

// Colour treatment of a banner card, mapped to theme roles by the UI.
enum BannerStyle { feature, primary, accent }

@freezed
abstract class PromoBanner with _$PromoBanner {
  const factory PromoBanner({
    required String id,
    required String tag,
    required String title,
    required String imagePath,
    required BannerStyle style,
  }) = _PromoBanner;
}

// How a section's tiles are drawn: wide photo tiles or square cards.
enum SectionLayout { wide, card }

@freezed
abstract class ProductSection with _$ProductSection {
  const factory ProductSection({
    required String id,
    required String title,
    required SectionLayout layout,
    required bool showFlame,
    required List<Product> products,
  }) = _ProductSection;
}

@freezed
abstract class Shop with _$Shop {
  const factory Shop({
    required String id,
    required String name,
    required String address,
    required String imagePath,
  }) = _Shop;
}
