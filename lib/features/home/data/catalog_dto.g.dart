// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  priceMmk: (json['priceMmk'] as num).toInt(),
  image: json['image'] as String,
  description: json['description'] as String,
  isNew: json['isNew'] as bool? ?? false,
  discountPercent: (json['discountPercent'] as num?)?.toInt(),
);

SectionDto _$SectionDtoFromJson(Map<String, dynamic> json) => SectionDto(
  id: json['id'] as String,
  title: json['title'] as String,
  layout: json['layout'] as String,
  products: (json['products'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  showFlame: json['showFlame'] as bool? ?? false,
);

BannerDto _$BannerDtoFromJson(Map<String, dynamic> json) => BannerDto(
  id: json['id'] as String,
  tag: json['tag'] as String,
  title: json['title'] as String,
  image: json['image'] as String,
  style: json['style'] as String,
);

ShopDto _$ShopDtoFromJson(Map<String, dynamic> json) => ShopDto(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  image: json['image'] as String,
);
