import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/app_assets.dart';

import '../helpers/app_harness.dart';

void main() {
  const declared = [
    AppAsset.google,
    AppAsset.apple,
    AppAsset.facebook,
    AppAsset.donutPinkSprinkle,
    AppAsset.donutBlueberry,
    AppAsset.donutStrawberryChoc,
    AppAsset.donutChocSprinkle,
    AppAsset.memberAvatar,
    AppAsset.seed,
  ];

  test('every AppAsset path exists and its folder is in pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in declared) {
      expect(File(path).existsSync(), isTrue, reason: '$path is missing');
      final folder = path.substring(0, path.lastIndexOf('/') + 1);
      expect(pubspec, contains('- $folder'), reason: '$folder not declared');
    }
  });

  test('catalogue images resolve to the bundled copy', () {
    expect(
      AppAsset.catalogImage('products/coconut.png'),
      'assets/images/products/coconut.png',
    );
  });

  testWidgets('Onboarding shows the Google, Apple and Facebook SVG icons', (
    tester,
  ) async {
    final app = await AppHarness.pump(tester);
    await tester.settle(const Duration(seconds: 2));
    for (final name in ['google', 'apple', 'facebook']) {
      expect(
        find.descendant(
          of: find.byKey(Key('social-$name')),
          matching: find.byType(SvgPicture),
        ),
        findsOneWidget,
      );
    }
    await app.dispose(tester);
  });
}
