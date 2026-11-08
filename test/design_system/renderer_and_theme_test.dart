import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/design_system/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart' as material;

import 'test_harness.dart';

void main() {
  group('useCupertino', () {
    tearDown(debugResetRendererOverrides);

    test('brand policy uses Material on every platform', () {
      rendererPolicy = RendererPolicy.brand;
      for (final platform in TargetPlatform.values) {
        debugOverrideTargetPlatform(platform);
        expect(useCupertino, isFalse, reason: platform.name);
      }
    });

    test('platform policy uses Cupertino only on iOS and macOS', () {
      rendererPolicy = RendererPolicy.platform;
      for (final platform in TargetPlatform.values) {
        debugOverrideTargetPlatform(platform);
        final apple =
            platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
        expect(useCupertino, apple, reason: platform.name);
      }
    });

    test('reset restores the brand policy', () {
      rendererPolicy = RendererPolicy.platform;
      debugOverrideTargetPlatform(TargetPlatform.iOS);
      debugResetRendererOverrides();
      expect(rendererPolicy, RendererPolicy.brand);
      expect(useCupertino, isFalse);
    });
  });

  group('AppTheme', () {
    test('maps tokens into Material', () {
      for (final c in [AppColorScheme.light, AppColorScheme.dark]) {
        final theme = AppTheme.toMaterial(c);
        expect(theme.brightness, c.brightness);
        expect(theme.colorScheme.primary, c.primary);
        expect(theme.colorScheme.onPrimary, c.onPrimary);
        expect(theme.colorScheme.surface, c.surface);
        expect(theme.colorScheme.error, c.error);
        expect(theme.scaffoldBackgroundColor, c.background);
        expect(
          theme.textTheme.bodyLarge?.fontSize,
          AppTypography.body.fontSize,
        );
        expect(theme.textTheme.bodyLarge?.color, c.onSurface);
      }
    });

    test('maps tokens into Cupertino', () {
      for (final c in [AppColorScheme.light, AppColorScheme.dark]) {
        final theme = AppTheme.toCupertino(c);
        expect(theme.brightness, c.brightness);
        expect(theme.primaryColor, c.primary);
        expect(theme.primaryContrastingColor, c.onPrimary);
        expect(theme.scaffoldBackgroundColor, c.background);
        expect(theme.textTheme.textStyle.fontSize, AppTypography.body.fontSize);
        expect(theme.textTheme.textStyle.color, c.onSurface);
      }
    });

    test('TypeStyle converts pixel line height to a ratio', () {
      const style = TypeStyle(fontSize: 16, lineHeight: 24);
      expect(style.toTextStyle().height, 1.5);
    });
  });

  forEachRenderer((policy) {
    final cupertinoBranch = policy == RendererPolicy.platform;

    for (final mode in [AppThemeMode.light, AppThemeMode.dark]) {
      testWidgets('${mode.name} tokens reach context.appTheme and the '
          'renderer theme', (tester) async {
        late BuildContext ctx;
        await pumpInApp(
          tester,
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
          themeMode: mode,
        );

        final expected = mode == AppThemeMode.dark
            ? AppColorScheme.dark
            : AppColorScheme.light;
        expect(ctx.appTheme.colors, same(expected));

        if (cupertinoBranch) {
          expect(find.byType(cupertino.CupertinoApp), findsOneWidget);
          final theme = cupertino.CupertinoTheme.of(ctx);
          expect(theme.brightness, expected.brightness);
          expect(theme.primaryColor, expected.primary);
        } else {
          expect(find.byType(material.MaterialApp), findsOneWidget);
          final theme = material.Theme.of(ctx);
          expect(theme.brightness, expected.brightness);
          expect(theme.colorScheme.primary, expected.primary);
        }
      });
    }

    testWidgets('system mode follows platform brightness', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      late BuildContext ctx;
      await pumpInApp(
        tester,
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
        themeMode: AppThemeMode.system,
      );
      expect(ctx.appTheme.colors, same(AppColorScheme.dark));
    });

    test('buildAdaptivePage picks the matching page type', () {
      final page = buildAdaptivePage<void>(
        key: const ValueKey('p'),
        child: const SizedBox(),
      );
      expect(
        page,
        cupertinoBranch
            ? isA<cupertino.CupertinoPage<void>>()
            : isA<material.MaterialPage<void>>(),
      );
    });
  });
}
