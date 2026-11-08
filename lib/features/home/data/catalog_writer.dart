import 'package:drift/drift.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/features/home/data/catalog_dto.dart';

// Writes a downloaded catalogue into the database in one transaction, so
// the UI never sees a half-updated Home.
class CatalogWriter {
  CatalogWriter(this._db);

  final AppDatabase _db;

  Future<void> replaceCatalog(CatalogDto catalog, DateTime now) {
    return _db.transaction(() async {
      await _db.batch((batch) {
        _products(batch, catalog.products, now);
        _sections(batch, catalog.sections);
        batch
          ..deleteAll(_db.banners)
          ..deleteAll(_db.shops);
        _banners(batch, catalog.banners);
        _shops(batch, catalog.shops);
      });
    });
  }

  void _products(Batch batch, List<ProductDto> products, DateTime now) {
    for (final (index, p) in products.indexed) {
      batch.insert(
        _db.products,
        ProductsCompanion.insert(
          id: p.id,
          code: p.code,
          name: p.name,
          priceMmk: p.priceMmk,
          isNew: Value(p.isNew),
          discountPercent: Value(p.discountPercent),
          imagePath: p.image,
          description: p.description,
          sortOrder: Value(index),
          updatedAt: Value(now),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  void _sections(Batch batch, List<SectionDto> sections) {
    for (final (index, s) in sections.indexed) {
      batch
        ..insert(
          _db.sections,
          SectionsCompanion.insert(
            id: s.id,
            title: s.title,
            layout: s.layout,
            showFlame: Value(s.showFlame),
            sortOrder: index,
          ),
          mode: InsertMode.insertOrReplace,
        )
        ..deleteWhere(_db.sectionProducts, (r) => r.sectionId.equals(s.id));
      for (final (position, productId) in s.products.indexed) {
        batch.insert(
          _db.sectionProducts,
          SectionProductsCompanion.insert(
            sectionId: s.id,
            productId: productId,
            position: position,
          ),
        );
      }
    }
  }

  void _banners(Batch batch, List<BannerDto> banners) {
    for (final (index, b) in banners.indexed) {
      batch.insert(
        _db.banners,
        BannersCompanion.insert(
          id: b.id,
          tag: b.tag,
          title: b.title,
          imagePath: b.image,
          style: b.style,
          sortOrder: index,
        ),
      );
    }
  }

  void _shops(Batch batch, List<ShopDto> shops) {
    for (final (index, s) in shops.indexed) {
      batch.insert(
        _db.shops,
        ShopsCompanion.insert(
          id: s.id,
          name: s.name,
          address: s.address,
          imagePath: s.image,
          sortOrder: index,
        ),
      );
    }
  }
}
