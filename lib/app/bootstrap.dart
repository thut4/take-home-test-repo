import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:jdonuts/app/app.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/database_seeder.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';

/// Seeds from the bundled JSON on first launch.
DatabaseSeeder bundledSeeder() =>
    DatabaseSeeder(loadJson: () => rootBundle.loadString(AppAsset.seed));

/// The app's provider container with the database injected and the stored
/// session restored, so a signed-in relaunch opens Home with no flash of
/// Onboarding. Tests pass their own [database] and [overrides].
Future<ProviderContainer> createAppContainer({
  AppDatabase? database,
  List<Override> overrides = const [],
}) async {
  rendererPolicy = RendererPolicy.brand;
  final db = database ?? AppDatabase.onDevice(seeder: bundledSeeder());
  final container = ProviderContainer(
    overrides: [databaseProvider.overrideWithValue(db), ...overrides],
  );
  await container.read(sessionControllerProvider.notifier).restore();
  return container;
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = await createAppContainer();
  runApp(
    UncontrolledProviderScope(container: container, child: const JDonutsApp()),
  );
}
