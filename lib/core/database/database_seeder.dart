import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:jdonuts/core/database/app_database.dart';

// Loads the bundled seed JSON (assets/seed/seed.json) on first launch, so
// the app works fully offline from the start.
class DatabaseSeeder {
  DatabaseSeeder({required this._loadJson});

  final Future<String> Function() _loadJson;

  static const seedVersionKey = 'seed_version';
  static const memberTemplateKey = 'member_template';

  Future<bool> needsSeed(AppDatabase db) async {
    final row = await (db.select(
      db.settings,
    )..where((s) => s.key.equals(seedVersionKey))).getSingleOrNull();
    return row == null;
  }

  Future<void> seed(AppDatabase db) async {
    final json = jsonDecode(await _loadJson()) as Map<String, dynamic>;
    final now = DateTime.now();
    await db.transaction(() async {
      await db.batch((batch) {
        _products(batch, db, _list(json, 'products'), now);
        _sections(batch, db, _list(json, 'sections'));
        _banners(batch, db, _list(json, 'banners'));
        _shops(batch, db, _list(json, 'shops'));
        _tiers(batch, db, _list(json, 'tiers'));
        _challenges(batch, db, _list(json, 'challenges'));
      });
      await _accounts(db, json, now);
      await db
          .into(db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(
              key: memberTemplateKey,
              value: jsonEncode(json['memberTemplate']),
            ),
          );
      await db
          .into(db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(
              key: seedVersionKey,
              value: '${json['version']}',
            ),
          );
    });
  }

  static List<Map<String, dynamic>> _list(Map<String, dynamic> j, String k) =>
      (j[k] as List<dynamic>).cast<Map<String, dynamic>>();

  void _products(
    Batch batch,
    AppDatabase db,
    List<Map<String, dynamic>> rows,
    DateTime now,
  ) {
    for (final (index, p) in rows.indexed) {
      batch.insert(
        db.products,
        ProductsCompanion.insert(
          id: p['id'] as String,
          code: p['code'] as String,
          name: p['name'] as String,
          priceMmk: p['priceMmk'] as int,
          isNew: Value(p['isNew'] as bool? ?? false),
          discountPercent: Value(p['discountPercent'] as int?),
          imagePath: p['image'] as String,
          description: p['description'] as String,
          sortOrder: Value(index),
          updatedAt: Value(now),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  void _sections(Batch b, AppDatabase db, List<Map<String, dynamic>> rows) {
    for (final (index, s) in rows.indexed) {
      final id = s['id'] as String;
      b.insert(
        db.sections,
        SectionsCompanion.insert(
          id: id,
          title: s['title'] as String,
          layout: s['layout'] as String,
          showFlame: Value(s['showFlame'] as bool? ?? false),
          sortOrder: index,
        ),
        mode: InsertMode.insertOrReplace,
      );
      final products = (s['products'] as List<dynamic>).cast<String>();
      for (final (position, productId) in products.indexed) {
        b.insert(
          db.sectionProducts,
          SectionProductsCompanion.insert(
            sectionId: id,
            productId: productId,
            position: position,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    }
  }

  void _banners(Batch b, AppDatabase db, List<Map<String, dynamic>> rows) {
    for (final (index, r) in rows.indexed) {
      b.insert(
        db.banners,
        BannersCompanion.insert(
          id: r['id'] as String,
          tag: r['tag'] as String,
          title: r['title'] as String,
          imagePath: r['image'] as String,
          style: r['style'] as String,
          sortOrder: index,
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  void _shops(Batch b, AppDatabase db, List<Map<String, dynamic>> rows) {
    for (final (index, r) in rows.indexed) {
      b.insert(
        db.shops,
        ShopsCompanion.insert(
          id: r['id'] as String,
          name: r['name'] as String,
          address: r['address'] as String,
          imagePath: r['image'] as String,
          sortOrder: index,
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  void _tiers(Batch b, AppDatabase db, List<Map<String, dynamic>> rows) {
    for (final r in rows) {
      b.insert(
        db.tiers,
        TiersCompanion.insert(
          id: r['id'] as String,
          name: r['name'] as String,
          rank: r['rank'] as int,
          pointsToNext: Value(r['pointsToNext'] as int?),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  void _challenges(Batch b, AppDatabase db, List<Map<String, dynamic>> rows) {
    for (final (index, r) in rows.indexed) {
      b.insert(
        db.challenges,
        ChallengesCompanion.insert(
          id: r['id'] as String,
          tab: r['tab'] as String,
          title: r['title'] as String,
          artwork: r['artwork'] as String,
          imagePath: r['image'] as String,
          progress: r['progress'] as int,
          goal: r['goal'] as int,
          points: r['points'] as int,
          sortOrder: index,
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  // Demo accounts, so the log-in path can be tried before registering.
  Future<void> _accounts(
    AppDatabase db,
    Map<String, dynamic> json,
    DateTime now,
  ) async {
    final template = json['memberTemplate'] as Map<String, dynamic>;
    for (final account in _list(json, 'accounts')) {
      final phone = account['phone'] as String;
      await db
          .into(db.users)
          .insertOnConflictUpdate(
            UsersCompanion.insert(
              phone: phone,
              firstName: account['firstName'] as String,
              lastName: Value(account['lastName'] as String?),
              dateOfBirth: DateTime.parse(account['dateOfBirth'] as String),
              createdAt: now,
            ),
          );
      await db
          .into(db.members)
          .insertOnConflictUpdate(memberFromTemplate(phone, template));
    }
  }

  // A fresh loyalty profile for [phone], from the seed's member template.
  static MembersCompanion memberFromTemplate(
    String phone,
    Map<String, dynamic> template,
  ) {
    return MembersCompanion.insert(
      phone: phone,
      photoPath: template['photo'] as String,
      tierId: template['tierId'] as String,
      tierPoints: template['tierPoints'] as int,
      totalPoints: template['totalPoints'] as int,
      notificationCount: template['notificationCount'] as int,
      rewardCount: template['rewardCount'] as int,
    );
  }
}
