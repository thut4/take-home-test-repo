import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:material_ui/material_ui.dart' as material;

import 'test_harness.dart';

void main() {
  forEachRenderer((policy) {
    final cupertinoBranch = policy == RendererPolicy.platform;

    group('AdaptiveButton', () {
      testWidgets('uses the native widget for each variant', (tester) async {
        await pumpInApp(
          tester,
          Column(
            children: [
              AdaptiveButton(label: 'P', onPressed: () {}),
              AdaptiveButton.secondary(label: 'S', onPressed: () {}),
              AdaptiveButton.text(label: 'T', onPressed: () {}),
            ],
          ),
        );
        if (cupertinoBranch) {
          expect(find.byType(cupertino.CupertinoButton), findsNWidgets(3));
        } else {
          expect(find.byType(material.FilledButton), findsOneWidget);
          expect(find.byType(material.OutlinedButton), findsOneWidget);
          expect(find.byType(material.TextButton), findsOneWidget);
        }
      });

      testWidgets('calls onPressed when enabled', (tester) async {
        var taps = 0;
        await pumpInApp(
          tester,
          AdaptiveButton(label: 'Go', onPressed: () => taps++),
        );
        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();
        expect(taps, 1);
      });

      testWidgets('ignores taps when onPressed is null', (tester) async {
        await pumpInApp(
          tester,
          const AdaptiveButton(label: 'Go', onPressed: null),
        );
        await tester.tap(find.text('Go'), warnIfMissed: false);
        await tester.pumpAndSettle();
        final semantics = tester.getSemantics(find.text('Go'));
        expect(semantics.flagsCollection.isEnabled, isNot(true));
      });

      testWidgets('loading disables taps and shows a spinner', (tester) async {
        var taps = 0;
        await pumpInApp(
          tester,
          AdaptiveButton(label: 'Go', isLoading: true, onPressed: () => taps++),
        );
        expect(find.byType(AdaptiveLoadingIndicator), findsOneWidget);
        // The label keeps its size and semantics while hidden.
        expect(find.text('Go'), findsOneWidget);
        await tester.tap(find.byType(AdaptiveButton), warnIfMissed: false);
        await tester.pump();
        expect(taps, 0);
      });

      testWidgets('expand fills the width', (tester) async {
        await pumpInApp(
          tester,
          AdaptiveButton(label: 'Wide', expand: true, onPressed: () {}),
        );
        final width = tester.getSize(find.byType(AdaptiveButton)).width;
        expect(
          width,
          tester.view.physicalSize.width / tester.view.devicePixelRatio,
        );
      });
    });

    group('AdaptiveSwitch', () {
      testWidgets('reports toggles', (tester) async {
        bool? next;
        await pumpInApp(
          tester,
          AdaptiveSwitch(value: false, onChanged: (v) => next = v),
        );
        expect(
          find.byType(
            cupertinoBranch ? cupertino.CupertinoSwitch : material.Switch,
          ),
          findsOneWidget,
        );
        await tester.tap(find.byType(AdaptiveSwitch));
        await tester.pumpAndSettle();
        expect(next, isTrue);
      });

      testWidgets('is inert when onChanged is null', (tester) async {
        await pumpInApp(
          tester,
          const AdaptiveSwitch(value: false, onChanged: null),
        );
        await tester.tap(find.byType(AdaptiveSwitch), warnIfMissed: false);
        await tester.pumpAndSettle();
        // No callback to call: just make sure nothing throws.
        expect(tester.takeException(), isNull);
      });
    });

    group('AdaptiveTextField', () {
      testWidgets('reports text changes and shows label and error', (
        tester,
      ) async {
        final changes = <String>[];
        await pumpInApp(
          tester,
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AdaptiveTextField(
              label: 'Email',
              placeholder: 'you@example.com',
              errorText: 'Required',
              onChanged: changes.add,
            ),
          ),
        );
        expect(
          find.byType(
            cupertinoBranch ? cupertino.CupertinoTextField : material.TextField,
          ),
          findsOneWidget,
        );
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Required'), findsOneWidget);

        await tester.enterText(find.byType(EditableText), 'a@b.co');
        expect(changes.last, 'a@b.co');
      });

      testWidgets('disabled field does not accept focus', (tester) async {
        await pumpInApp(
          tester,
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: AdaptiveTextField(placeholder: 'Off', enabled: false),
          ),
        );
        await tester.tap(find.byType(AdaptiveTextField), warnIfMissed: false);
        await tester.pump();
        final editable = tester.widget<EditableText>(find.byType(EditableText));
        expect(editable.focusNode.hasFocus, isFalse);
      });
    });

    group('AdaptiveListTile', () {
      testWidgets('shows text and handles taps', (tester) async {
        var taps = 0;
        await pumpInApp(
          tester,
          AdaptiveListTile(
            title: 'Row',
            subtitle: 'Detail',
            onTap: () => taps++,
          ),
        );
        expect(find.text('Detail'), findsOneWidget);
        expect(
          find.byType(cupertino.CupertinoListTileChevron),
          cupertinoBranch ? findsOneWidget : findsNothing,
        );
        await tester.tap(find.text('Row'));
        await tester.pumpAndSettle();
        expect(taps, 1);
      });
    });

    group('showAdaptiveConfirmDialog', () {
      Future<Future<bool>> open(WidgetTester tester) async {
        late BuildContext ctx;
        await pumpInApp(
          tester,
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        );
        final result = showAdaptiveConfirmDialog(
          ctx,
          title: 'Delete?',
          message: 'Gone for good.',
          confirmLabel: 'Delete',
          isDestructive: true,
        );
        await tester.pumpAndSettle();
        // Hands back the still-open dialog's future so the test can tap a
        // button before awaiting it.
        // ignore: async_return_with_no_await
        return result;
      }

      testWidgets('presents the native dialog', (tester) async {
        await open(tester);
        expect(
          find.byType(
            cupertinoBranch
                ? cupertino.CupertinoAlertDialog
                : material.AlertDialog,
          ),
          findsOneWidget,
        );
        expect(find.text('Delete?'), findsOneWidget);
        expect(find.text('Gone for good.'), findsOneWidget);
      });

      testWidgets('returns true on confirm', (tester) async {
        final result = await open(tester);
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        expect(await result, isTrue);
        expect(find.text('Delete?'), findsNothing);
      });

      testWidgets('returns false on cancel', (tester) async {
        final result = await open(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(await result, isFalse);
      });

      testWidgets('barrier tap dismisses only on Material', (tester) async {
        final result = await open(tester);
        await tester.tapAt(const Offset(4, 4));
        await tester.pumpAndSettle();
        if (cupertinoBranch) {
          expect(find.text('Delete?'), findsOneWidget);
        } else {
          expect(find.text('Delete?'), findsNothing);
          expect(await result, isFalse);
        }
      });
    });

    group('state views', () {
      testWidgets('loading view shows indicator and message', (tester) async {
        await pumpInApp(tester, const AppLoadingView(message: 'Fetching'));
        expect(find.byType(AdaptiveLoadingIndicator), findsOneWidget);
        expect(find.text('Fetching'), findsOneWidget);
        expect(
          find.byType(
            cupertinoBranch
                ? cupertino.CupertinoActivityIndicator
                : material.CircularProgressIndicator,
          ),
          findsOneWidget,
        );
      });

      testWidgets('error view retries', (tester) async {
        var retries = 0;
        await pumpInApp(
          tester,
          AppErrorView(message: 'Offline', onRetry: () => retries++),
        );
        expect(find.text('Something went wrong'), findsOneWidget);
        await tester.tap(find.text('Try again'));
        await tester.pumpAndSettle();
        expect(retries, 1);
      });

      testWidgets('empty view runs its action', (tester) async {
        var actions = 0;
        await pumpInApp(
          tester,
          AppEmptyView(
            title: 'Nothing here',
            actionLabel: 'Add',
            onAction: () => actions++,
          ),
        );
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();
        expect(actions, 1);
      });

      testWidgets('error view without onRetry has no button', (tester) async {
        await pumpInApp(tester, const AppErrorView());
        expect(find.byType(AdaptiveButton), findsNothing);
      });
    });
  });
}
