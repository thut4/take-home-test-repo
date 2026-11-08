import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/product/data/drift_product_repository.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/features/product/domain/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => DriftProductRepository(ref.watch(databaseProvider)),
);

final StreamProviderFamily<Product, String> productProvider = StreamProvider
    .autoDispose
    .family<Product, String>(
      (ref, id) => ref
          .watch(productRepositoryProvider)
          .watchProduct(id)
          .map((result) => result.getOrThrow()),
    );

final StreamProvider<int> cartCountProvider = StreamProvider.autoDispose<int>(
  (ref) => ref
      .watch(productRepositoryProvider)
      .watchCartCount()
      .map((result) => result.getOrThrow()),
);
