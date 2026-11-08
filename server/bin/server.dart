// Mock J'Donuts API.
//
//   cd server && dart pub get && dart run bin/server.dart
//
// GET /v1/health, /v1/products, /v1/sections, /v1/banners, /v1/shops and
// /images/<path>. Every JSON response is {data, error, meta}. Add
// `?fail=1` to any /v1 route to get an error envelope, and set
// MOCK_LATENCY_MS to slow responses down.
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

const apiVersion = 'v1';
const defaultPort = 8080;

Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent.path;
  final catalog = jsonDecode(
    File('$root/data/catalog.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  final latency = Duration(
    milliseconds: int.tryParse(Platform.environment['MOCK_LATENCY_MS'] ?? '') ?? 0,
  );

  final api = Router()
    ..get('/$apiVersion/health', (Request r) => _envelope(r, {'ok': true}))
    ..get('/$apiVersion/<collection>', (Request r, String collection) {
      final data = catalog[collection];
      if (data == null) return _error(404, 'not_found', 'No $collection');
      return _envelope(r, data);
    });

  // Server-only images first, then the app's bundled seed images.
  final images = Cascade()
      .add(createStaticHandler('$root/public/images'))
      .add(createStaticHandler('$root/../assets/images'))
      .handler;

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_delay(latency))
      .addHandler(
        Cascade().add(api.call).add(_mount('/images/', images)).handler,
      );

  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? defaultPort;
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  stdout.writeln('J\'Donuts mock API on http://localhost:${server.port}');
}

Response _envelope(Request request, Object data) {
  if (request.url.queryParameters['fail'] == '1') {
    return _error(500, 'forced_failure', 'Failure requested with ?fail=1');
  }
  return _json(200, {
    'data': data,
    'error': null,
    'meta': {
      'version': apiVersion,
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
    },
  });
}

Response _error(int status, String code, String message) => _json(status, {
  'data': null,
  'error': {'code': code, 'message': message},
  'meta': {'version': apiVersion},
});

Response _json(int status, Object body) => Response(
  status,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Handler _mount(String prefix, Handler inner) => (request) {
  final path = '/${request.url.path}';
  if (!path.startsWith(prefix)) return Response.notFound('Not found');
  return inner(request.change(path: prefix.substring(1)));
};

Middleware _delay(Duration latency) => (inner) => (request) async {
  if (latency > Duration.zero) await Future<void>.delayed(latency);
  return inner(request);
};
