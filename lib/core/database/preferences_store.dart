import 'package:jdonuts/core/database/app_database.dart';

// Small string preferences (chosen language) in the `settings` table.
class PreferencesStore {
  PreferencesStore(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final row = await (_db.select(
      _db.settings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) => _db
      .into(_db.settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
}
