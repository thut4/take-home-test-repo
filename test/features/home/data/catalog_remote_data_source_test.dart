import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/network/api_client.dart';
import 'package:jdonuts/core/network/dio_factory.dart';
import 'package:jdonuts/core/network/server_health_check.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/home/data/catalog_remote_data_source.dart';

const _baseUrl = 'http://server.test';

// Answers every request with an empty list, or refuses the connection.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter({required this.serverUp});

  final bool serverUp;
  final requestedPaths = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestedPaths.add(options.path);
    if (!serverUp) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'Connection refused',
      );
    }
    return ResponseBody.fromString(
      '{"data":[],"error":null}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

CatalogRemoteDataSource _remote(_FakeAdapter adapter) {
  final api = createDio(baseUrl: _baseUrl)..httpClientAdapter = adapter;
  final probe = createHealthProbeDio(baseUrl: _baseUrl)
    ..httpClientAdapter = adapter;
  return CatalogRemoteDataSource(ApiClient(api), ServerHealthCheck(probe));
}

void main() {
  test('a stopped server costs one health request and nothing else', () async {
    final adapter = _FakeAdapter(serverUp: false);

    final result = await _remote(adapter).fetchCatalog();

    expect(result.failureOrNull, isA<NetworkFailure>());
    expect(adapter.requestedPaths, ['/v1/health']);
  });

  test(
    'a healthy server is checked once, then every list is fetched',
    () async {
      final adapter = _FakeAdapter(serverUp: true);

      final result = await _remote(adapter).fetchCatalog();

      expect(result, isA<Ok<Object?>>());
      expect(adapter.requestedPaths, [
        '/v1/health',
        '/v1/products',
        '/v1/sections',
        '/v1/banners',
        '/v1/shops',
      ]);
    },
  );
}
