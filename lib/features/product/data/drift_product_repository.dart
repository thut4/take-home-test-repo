import 'package:drift/drift.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/watch_result.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/logger.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/features/product/domain/product_repository.dart';

class DriftProductRepository implements ProductRepository {
  DriftProductRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Result<Product>> watchProduct(String id) {
    final query = _db.select(_db.products)..where((p) => p.id.equals(id));
    return watchResult(
      'watchProduct',
      query.watchSingleOrNull().map((row) {
        if (row == null) throw NotFoundFailure('product $id');
        return productFromRow(row);
      }),
    );
  }

  @override
  Future<Result<int>> addToCart(String productId, int quantity) async {
    try {
      await _db.customStatement(
        'INSERT INTO cart_items (product_id, quantity) VALUES (?, ?) '
        'ON CONFLICT(product_id) DO UPDATE SET '
        'quantity = quantity + excluded.quantity',
        [productId, QuantityLimits.clamp(quantity)],
      );
      _db.notifyUpdates({TableUpdate.onTable(_db.cartItems)});
      return Ok(await _cartCount().getSingle() ?? 0);
    } on Object catch (error, stackTrace) {
      logFailure('addToCart', error, stackTrace);
      return Err(CacheFailure('$error'));
    }
  }

  @override
  Stream<Result<int>> watchCartCount() => watchResult(
    'watchCartCount',
    _cartCount().watchSingle().map((count) => count ?? 0),
  );

  Selectable<int?> _cartCount() {
    final sum = _db.cartItems.quantity.sum();
    return (_db.selectOnly(
      _db.cartItems,
    )..addColumns([sum])).map((row) => row.read(sum));
  }
}

/// Shared with Home, which lists the same rows.
Product productFromRow(ProductRow row) => Product(
  id: row.id,
  code: row.code,
  name: row.name,
  priceMmk: row.priceMmk,
  isNew: row.isNew,
  discountPercent: row.discountPercent,
  imagePath: row.imagePath,
  description: row.description,
);
