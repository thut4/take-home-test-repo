import 'package:json_annotation/json_annotation.dart';

part 'catalog_dto.g.dart';

// Wire format of `/v1/products` items.
@JsonSerializable(createToJson: false)
class ProductDto {
  const ProductDto({
    required this.id,
    required this.code,
    required this.name,
    required this.priceMmk,
    required this.image,
    required this.description,
    this.isNew = false,
    this.discountPercent,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  final String id;
  final String code;
  final String name;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;
  final String image;
  final String description;
}

// Wire format of `/v1/sections` items.
@JsonSerializable(createToJson: false)
class SectionDto {
  const SectionDto({
    required this.id,
    required this.title,
    required this.layout,
    required this.products,
    this.showFlame = false,
  });

  factory SectionDto.fromJson(Map<String, dynamic> json) =>
      _$SectionDtoFromJson(json);

  final String id;
  final String title;
  final String layout;
  final bool showFlame;
  final List<String> products;
}

// Wire format of `/v1/banners` items.
@JsonSerializable(createToJson: false)
class BannerDto {
  const BannerDto({
    required this.id,
    required this.tag,
    required this.title,
    required this.image,
    required this.style,
  });

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);

  final String id;
  final String tag;
  final String title;
  final String image;
  final String style;
}

// Wire format of `/v1/shops` items.
@JsonSerializable(createToJson: false)
class ShopDto {
  const ShopDto({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
  });

  factory ShopDto.fromJson(Map<String, dynamic> json) =>
      _$ShopDtoFromJson(json);

  final String id;
  final String name;
  final String address;
  final String image;
}

// Everything one refresh brings down.
typedef CatalogDto = ({
  List<ProductDto> products,
  List<SectionDto> sections,
  List<BannerDto> banners,
  List<ShopDto> shops,
});
