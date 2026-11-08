import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/database/app_database.dart';

import '../helpers/test_database.dart';

void main() {
  test('first launch seeds every table from the bundled JSON', () async {
    final db = seededDatabase();
    addTearDown(db.close);
    expect(await db.select(db.products).get(), hasLength(13));
    expect(await db.select(db.sections).get(), hasLength(3));
    expect(await db.select(db.shops).get(), hasLength(4));
    expect(await db.select(db.tiers).get(), hasLength(4));
    expect(await db.select(db.users).get(), hasLength(1));
  });

  test('seeding runs once: a second open keeps local changes', () async {
    final db = seededDatabase();
    addTearDown(db.close);
    await db.delete(db.shops).go();
    final seeder = fileSeeder();
    expect(await seeder.needsSeed(db), isFalse);
  });

  test('migrates a v1 database to v2 without losing data', () async {
    final executor = NativeDatabase.memory(
      setup: (raw) {
        raw
          ..execute(
            'CREATE TABLE products (id TEXT NOT NULL PRIMARY KEY, '
            'code TEXT NOT NULL, name TEXT NOT NULL, '
            'price_mmk INTEGER NOT NULL, is_new INTEGER NOT NULL DEFAULT 0, '
            'discount_percent INTEGER, image_path TEXT NOT NULL, '
            'description TEXT NOT NULL, sort_order INTEGER NOT NULL DEFAULT 0)',
          )
          ..execute(
            "INSERT INTO products VALUES ('p1', 'JD1', 'Old donut', 1000, 0, "
            "NULL, 'products/coconut.png', 'Kept across the upgrade', 0)",
          )
          ..execute(
            'CREATE TABLE settings (key TEXT NOT NULL PRIMARY KEY, '
            'value TEXT NOT NULL)',
          )
          ..execute('PRAGMA user_version = 1');
      },
    );
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final db = AppDatabase(executor);
    addTearDown(db.close);

    final product = await db.select(db.products).getSingle();
    expect(product.name, 'Old donut');
    expect(product.updatedAt, isNotNull);
    await db
        .into(db.cartItems)
        .insert(CartItemsCompanion.insert(productId: 'p1', quantity: 2));
    expect(await db.select(db.cartItems).get(), hasLength(1));
  });
}
