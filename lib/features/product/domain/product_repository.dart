import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/product/domain/product.dart';

abstract interface class ProductRepository {
  // Fails with `NotFoundFailure` when no product has [id].
  Stream<Result<Product>> watchProduct(String id);

  // Adds [quantity] of the product to the persistent cart. Returns the new
  // number of items in the cart.
  Future<Result<int>> addToCart(String productId, int quantity);

  // Total items in the cart.
  Stream<Result<int>> watchCartCount();
}
