import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/app/routes.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/product/data/drift_product_repository.dart';
import 'package:jdonuts/features/product/domain/product.dart';
import 'package:jdonuts/features/product/domain/product_repository.dart';
import 'package:jdonuts/features/product/product_providers.dart';
import 'package:material_ui/material_ui.dart' as material;

import '../../helpers/app_harness.dart';

const _productId = 'p_mistletoe_box';
const _addButton = Key('add-to-cart');
const _increase = Key('quantity-increase');

class _FailingCartRepository implements ProductRepository {
  _FailingCartRepository(this._inner);

  final ProductRepository _inner;

  @override
  Stream<Result<Product>> watchProduct(String id) => _inner.watchProduct(id);

  @override
  Stream<Result<int>> watchCartCount() => _inner.watchCartCount();

  @override
  Future<Result<int>> addToCart(String productId, int quantity) async =>
      const Err(CacheFailure('disk full'));
}

Future<void> _openProduct(WidgetTester tester) async {
  await tester.settle(const Duration(seconds: 2));
  unawaited(GoRouterFinder.of(tester).push(Routes.product(_productId)));
  await tester.settle();
}

Future<void> _addTwo(WidgetTester tester) async {
  await tester.tap(find.byKey(_increase));
  await tester.settle();
  expect(find.text('2'), findsOneWidget);
  await tester.tap(find.byKey(_addButton));
  await tester.settle();
}

void main() {
  testWidgets('a successful add reports the quantity, then resets it', (
    tester,
  ) async {
    final app = await AppHarness.pump(tester, signedInPhone: '+959123456789');
    await _openProduct(tester);

    await _addTwo(tester);

    expect(
      find.text('Added 2 × Mistletoe Romance box to your cart.'),
      findsOneWidget,
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsNothing);

    await app.dispose(tester);
  });

  testWidgets('a failed add keeps the quantity for a retry', (tester) async {
    final app = await AppHarness.pump(
      tester,
      signedInPhone: '+959123456789',
      overrides: [
        productRepositoryProvider.overrideWith(
          (ref) => _FailingCartRepository(
            DriftProductRepository(ref.watch(databaseProvider)),
          ),
        ),
      ],
    );
    await _openProduct(tester);

    await _addTwo(tester);

    expect(find.textContaining('Added'), findsNothing);
    expect(find.text('2'), findsOneWidget);

    await app.dispose(tester);
  });

  for (final (name, safeBottom) in [
    ('no home indicator', 0.0),
    ('a home indicator', 34.0),
  ]) {
    testWidgets('the snackbar clears the add button with $name', (
      tester,
    ) async {
      final inset = FakeViewPadding(
        bottom: safeBottom * AppHarness.phonePixelRatio,
      );
      tester.view
        ..padding = inset
        ..viewPadding = inset;
      final app = await AppHarness.pump(tester, signedInPhone: '+959123456789');
      await _openProduct(tester);

      await tester.tap(find.byKey(_addButton));
      await tester.settle();

      final snackbar = tester.getRect(
        find
            .descendant(
              of: find.byType(material.SnackBar),
              matching: find.byType(material.Material),
            )
            .first,
      );
      final button = tester.getRect(find.byKey(_addButton));
      expect(snackbar.bottom, lessThanOrEqualTo(button.top));

      await app.dispose(tester);
    });
  }
}
