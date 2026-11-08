import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/design_system/design_system.dart';

/// Runs [body] once per [RendererPolicy] with the platform forced to iOS, so
/// `brand` exercises the Material branch and `platform` the Cupertino one.
void forEachRenderer(void Function(RendererPolicy policy) body) {
  for (final policy in RendererPolicy.values) {
    group('${policy.name} renderer', () {
      setUp(() {
        rendererPolicy = policy;
        debugOverrideTargetPlatform(TargetPlatform.iOS);
      });
      tearDown(debugResetRendererOverrides);
      body(policy);
    });
  }
}

/// Pumps [child] inside the real app root, so themes, localizations and the
/// renderer choice match the app.
Future<void> pumpInApp(
  WidgetTester tester,
  Widget child, {
  AppThemeMode themeMode = AppThemeMode.light,
}) async {
  await tester.pumpWidget(
    AdaptiveApp.home(
      themeMode: themeMode,
      home: AdaptiveScaffold(body: Center(child: child)),
    ),
  );
}
