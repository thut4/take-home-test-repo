import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/network/api_client.dart';
import 'package:jdonuts/core/network/server_health_check.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/home/data/catalog_dto.dart';
import 'package:jdonuts/features/home/data/catalog_remote_data_source.dart';
import 'package:jdonuts/features/home/data/drift_home_repository.dart';
import 'package:jdonuts/features/home/domain/home_content.dart';

import '../../../helpers/test_database.dart';

class _FakeRemote extends CatalogRemoteDataSource {
  _FakeRemote(this.response)
    : super(ApiClient(Dio()), ServerHealthCheck(Dio()));

  Result<CatalogDto> response;

  @override
  Future<Result<CatalogDto>> fetchCatalog() async => response;
}

const _matcha = ProductDto(
  id: 'p_matcha',
  code: 'JD022130',
  name: 'Matcha Glazed Donut',
  priceMmk: 3000,
  image: 'products/matcha.png',
  description: 'Server only',
  isNew: true,
);

void main() {
  late AppDatabase db;
  late _FakeRemote remote;
  late DriftHomeRepository repository;
  final now = DateTime(2026, 11, 8, 12);

  setUp(() {
    db = seededDatabase();
    remote = _FakeRemote(const Err(NetworkFailure()));
    repository = DriftHomeRepository(db, remote, clock: () => now);
  });

  tearDown(() => db.close());

  test(
    'Home reads the seeded sections with their products, in order',
    () async {
      final sections = (await repository.watchSections().first).getOrThrow();
      expect(sections.map((s) => s.id), ['seasonal', 'popular', 'order_again']);
      expect(sections.first.layout, SectionLayout.wide);
      expect(sections[1].products.first.name, 'Strawberry Chocolate Donuts');
    },
  );

  test(
    'a failed refresh keeps the local data and reports the failure',
    () async {
      final result = await repository.refresh();
      expect(result.failureOrNull, isA<NetworkFailure>());
      final shops = (await repository.watchShops().first).getOrThrow();
      expect(shops, hasLength(4));
    },
  );

  test(
    'a successful refresh writes the server catalogue into the database',
    () async {
      remote.response = const Ok((
        products: [_matcha],
        sections: [
          SectionDto(
            id: 'popular',
            title: 'Popular',
            layout: 'card',
            products: ['p_matcha', 'p_coconut'],
            showFlame: true,
          ),
        ],
        banners: [
          BannerDto(
            id: 'b1',
            tag: 'New',
            title: 'Matcha',
            image: 'products/matcha.png',
            style: 'accent',
          ),
        ],
        shops: <ShopDto>[],
      ));

      expect(await repository.refresh(), Ok(now));

      final sections = (await repository.watchSections().first).getOrThrow();
      final popular = sections.firstWhere((s) => s.id == 'popular');
      expect(popular.products.map((p) => p.id), ['p_matcha', 'p_coconut']);
      final banners = (await repository.watchBanners().first).getOrThrow();
      expect(banners.single.style, BannerStyle.accent);
    },
  );
}
