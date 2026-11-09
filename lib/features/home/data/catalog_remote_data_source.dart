import 'package:jdonuts/core/network/api_client.dart';
import 'package:jdonuts/core/network/server_health_check.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/home/data/catalog_dto.dart';

// The public catalogue on the mock server (`/v1/...`).
class CatalogRemoteDataSource {
  CatalogRemoteDataSource(this._api, this._health);

  final ApiClient _api;
  final ServerHealthCheck _health;

  Future<Result<CatalogDto>> fetchCatalog() async {
    final unavailable = await _health.check();
    if (unavailable != null) return Err(unavailable);
    final results = await (
      _list('/v1/products', ProductDto.fromJson),
      _list('/v1/sections', SectionDto.fromJson),
      _list('/v1/banners', BannerDto.fromJson),
      _list('/v1/shops', ShopDto.fromJson),
    ).wait;
    return switch (results) {
      (
        Ok(value: final p),
        Ok(value: final s),
        Ok(value: final b),
        Ok(value: final sh),
      ) =>
        Ok((products: p, sections: s, banners: b, shops: sh)),
      (final p, final s, final b, final sh) => Err(
        [p, s, b, sh].map((r) => r.failureOrNull).nonNulls.first,
      ),
    };
  }

  Future<Result<List<T>>> _list<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return _api.get(
      path,
      (data) => (data! as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(fromJson)
          .toList(),
    );
  }
}
