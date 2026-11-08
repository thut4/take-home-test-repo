import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the design system's dependency boundaries.
void main() {
  final packageName = RegExp(
    r'^name:\s*(\S+)',
    multiLine: true,
  ).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1)!;

  const designSystemDir = 'lib/design_system/';
  const barrel = '${designSystemDir}design_system.dart';
  const uiPackages = ['package:material_ui/', 'package:cupertino_ui/'];
  const inSdkLibraries = [
    'package:flutter/material.dart',
    'package:flutter/cupertino.dart',
  ];

  final directive = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''');

  List<String> dartFiles(String dir) =>
      Directory(dir)
          .listSync(recursive: true)
          .whereType<File>()
          .map((f) => f.path.replaceAll(r'\', '/'))
          .where((p) => p.endsWith('.dart'))
          .toList()
        ..sort();

  /// (file, uri) pairs, with relative and package URIs normalised to a
  /// `lib/...` path where they point into this package.
  Iterable<(String, String)> directives(List<String> files) sync* {
    for (final file in files) {
      for (final line in File(file).readAsLinesSync()) {
        final uri = directive.firstMatch(line)?.group(1);
        if (uri == null) continue;
        if (uri.startsWith('package:$packageName/')) {
          yield (file, 'lib/${uri.substring('package:$packageName/'.length)}');
        } else if (!uri.contains(':')) {
          // File paths are relative to the package root, so a resolved
          // relative import is too (Uri.resolve normalises `..`).
          yield (file, Uri.parse(file).resolve(uri).path);
        } else {
          yield (file, uri);
        }
      }
    }
  }

  bool isUiPackage(String uri) => uiPackages.any(uri.startsWith);
  bool mayImportUi(String file) =>
      file == '${designSystemDir}theme/app_theme.dart' ||
      file.startsWith('${designSystemDir}components/');

  final libFiles = dartFiles('lib');
  final testFiles = dartFiles('test');

  test('nothing imports the in-SDK Material or Cupertino libraries', () {
    final violations = [
      for (final (file, uri) in directives([...libFiles, ...testFiles]))
        if (inSdkLibraries.contains(uri)) '$file -> $uri',
    ];
    expect(violations, isEmpty);
  });

  test('only theme/app_theme.dart and components/ import UI packages', () {
    final violations = [
      for (final (file, uri) in directives(libFiles))
        if (isUiPackage(uri) && !mayImportUi(file)) '$file -> $uri',
    ];
    expect(violations, isEmpty);
  });

  test('code outside the design system imports only its barrel', () {
    final violations = [
      for (final (file, uri) in directives(libFiles))
        if (!file.startsWith(designSystemDir) &&
            uri.startsWith(designSystemDir) &&
            uri != barrel)
          '$file -> $uri',
    ];
    expect(violations, isEmpty);
  });

  test('domain layers are pure Dart: no Flutter, no data or presentation', () {
    final domainFiles = libFiles.where((f) => f.contains('/domain/'));
    final violations = [
      for (final (file, uri) in directives(domainFiles.toList()))
        if (uri.startsWith('package:flutter/') ||
            uri.startsWith('package:flutter_riverpod/') ||
            uri.contains('/data/') ||
            uri.contains('/presentation/'))
          '$file -> $uri',
    ];
    expect(violations, isEmpty);
  });

  test('presentation never imports a data source directly', () {
    final screens = libFiles.where((f) => f.contains('/presentation/'));
    final violations = [
      for (final (file, uri) in directives(screens.toList()))
        if (uri.contains('/data/') && !uri.endsWith('session_store.dart'))
          '$file -> $uri',
    ];
    expect(violations, isEmpty);
  });
}
