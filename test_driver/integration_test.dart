import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Runs the integration test and saves its screenshots to
/// build/screenshots/ (used for the README and to check UI fidelity).
Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    File('build/screenshots/$name.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes);
    return true;
  },
);
