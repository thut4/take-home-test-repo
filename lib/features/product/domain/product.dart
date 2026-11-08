import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String code,
    required String name,
    required int priceMmk,
    required bool isNew,
    required String imagePath,
    required String description,
    int? discountPercent,
  }) = _Product;

  const Product._();

  // Price of [quantity] items, in kyat.
  int totalFor(int quantity) => priceMmk * quantity;
}

// Quantity stepper limits on Product detail.
abstract final class QuantityLimits {
  static const min = 1;
  static const max = 99;

  static int clamp(int quantity) => quantity.clamp(min, max);
}
