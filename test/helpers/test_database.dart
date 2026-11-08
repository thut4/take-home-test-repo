import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/database_seeder.dart';

/// The real seed file, read from disk (tests have no asset bundle).
DatabaseSeeder fileSeeder() =>
    DatabaseSeeder(loadJson: () => File(AppAsset.seed).readAsString());

/// A fresh in-memory database, seeded like a first launch.
AppDatabase seededDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(NativeDatabase.memory(), seeder: fileSeeder());
}
