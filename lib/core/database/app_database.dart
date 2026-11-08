import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:jdonuts/core/database/database_seeder.dart';
import 'package:jdonuts/core/database/tables.dart';

part 'app_database.g.dart';

// The local database: the single source of truth every screen reads.
//
// Schema history:
// - v1: catalogue, sections, banners, shops, users, members, tiers,
//   challenges, settings.
// - v2: `cart_items` table and `products.updated_at`.
@DriftDatabase(
  tables: [
    Products,
    Sections,
    SectionProducts,
    Banners,
    Shops,
    Users,
    Members,
    Tiers,
    Challenges,
    CartItems,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {this.seeder});

  // The on-device database file.
  factory AppDatabase.onDevice({required DatabaseSeeder seeder}) =>
      AppDatabase(driftDatabase(name: databaseName), seeder: seeder);

  static const databaseName = 'jdonuts';

  // Fills a newly created database from the bundled JSON.
  final DatabaseSeeder? seeder;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: _upgrade,
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      final seeder = this.seeder;
      if (seeder != null && await seeder.needsSeed(this)) {
        await seeder.seed(this);
      }
    },
  );

  Future<void> _upgrade(Migrator migrator, int from, int to) async {
    if (from < 2) {
      await migrator.createTable(cartItems);
      await migrator.addColumn(products, products.updatedAt);
      await customStatement(
        'UPDATE products '
        "SET updated_at = CAST(strftime('%s', 'now') AS INTEGER)",
      );
    }
  }
}
