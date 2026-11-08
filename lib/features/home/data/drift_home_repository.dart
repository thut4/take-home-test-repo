import 'package:drift/drift.dart';
import 'package:jdonuts/core/clock.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/watch_result.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/logger.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/home/data/catalog_dto.dart';
import 'package:jdonuts/features/home/data/catalog_remote_data_source.dart';
import 'package:jdonuts/features/home/data/catalog_writer.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';
import 'package:jdonuts/features/home/domain/home_repository.dart';
import 'package:jdonuts/features/product/data/drift_product_repository.dart';

// Offline-first Home data: the UI only ever reads the database; the server
// (when reachable) refreshes it.
class DriftHomeRepository implements HomeRepository {
  DriftHomeRepository(this._db, this._remote, {this._clock = systemClock});

  static const lastRefreshKey = 'catalog_refreshed_at';

  final AppDatabase _db;
  final CatalogRemoteDataSource _remote;
  final Clock _clock;

  @override
  Stream<Result<List<PromoBanner>>> watchBanners() {
    final query = _db.select(_db.banners)
      ..orderBy([(b) => OrderingTerm(expression: b.sortOrder)]);
    return watchResult(
      'watchBanners',
      query.watch().map((rows) => rows.map(_toBanner).toList()),
    );
  }

  @override
  Stream<Result<List<Shop>>> watchShops() {
    final query = _db.select(_db.shops)
      ..orderBy([(s) => OrderingTerm(expression: s.sortOrder)]);
    return watchResult(
      'watchShops',
      query.watch().map((rows) => rows.map(_toShop).toList()),
    );
  }

  @override
  Stream<Result<List<ProductSection>>> watchSections() {
    final query =
        _db.select(_db.sections).join([
          leftOuterJoin(
            _db.sectionProducts,
            _db.sectionProducts.sectionId.equalsExp(_db.sections.id),
          ),
          leftOuterJoin(
            _db.products,
            _db.products.id.equalsExp(_db.sectionProducts.productId),
          ),
        ])..orderBy([
          OrderingTerm(expression: _db.sections.sortOrder),
          OrderingTerm(expression: _db.sectionProducts.position),
        ]);
    return watchResult('watchSections', query.watch().map(_groupSections));
  }

  @override
  Future<Result<DateTime>> refresh() async {
    final fetched = await _remote.fetchCatalog();
    final CatalogDto catalog;
    switch (fetched) {
      case Err(:final failure):
        return Err(failure);
      case Ok(:final value):
        catalog = value;
    }
    final now = _clock();
    try {
      await CatalogWriter(_db).replaceCatalog(catalog, now);
      await _db
          .into(_db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(
              key: lastRefreshKey,
              value: now.toIso8601String(),
            ),
          );
      return Ok(now);
    } on Object catch (error, stackTrace) {
      logFailure('refresh', error, stackTrace);
      return Err(CacheFailure('$error'));
    }
  }

  List<ProductSection> _groupSections(List<TypedResult> rows) {
    final sections = <String, ProductSection>{};
    for (final row in rows) {
      final section = row.readTable(_db.sections);
      final product = row.readTableOrNull(_db.products);
      final current = sections[section.id] ?? _toSection(section);
      sections[section.id] = product == null
          ? current
          : current.copyWith(
              products: [...current.products, productFromRow(product)],
            );
    }
    return sections.values.toList();
  }

  static ProductSection _toSection(SectionRow row) => ProductSection(
    id: row.id,
    title: row.title,
    layout: SectionLayout.values.asNameMap()[row.layout] ?? SectionLayout.card,
    showFlame: row.showFlame,
    products: const [],
  );

  static PromoBanner _toBanner(BannerRow row) => PromoBanner(
    id: row.id,
    tag: row.tag,
    title: row.title,
    imagePath: row.imagePath,
    style: BannerStyle.values.asNameMap()[row.style] ?? BannerStyle.primary,
  );

  static Shop _toShop(ShopRow row) => Shop(
    id: row.id,
    name: row.name,
    address: row.address,
    imagePath: row.imagePath,
  );
}
