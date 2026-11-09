import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/clock.dart';
import 'package:jdonuts/core/connectivity/connectivity_service.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/env.dart';
import 'package:jdonuts/core/network/api_client.dart';
import 'package:jdonuts/core/network/dio_factory.dart';
import 'package:jdonuts/core/network/server_health_check.dart';

// Infrastructure every feature shares. Tests override any of these.

// Opened in `bootstrap()` and injected with an override, because opening
// it is asynchronous.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

final clockProvider = Provider<Clock>((ref) => systemClock);

final envProvider = Provider<Env>((ref) => Env.fromEnvironment());

final dioProvider = Provider<Dio>((ref) {
  final dio = createDio(baseUrl: ref.watch(envProvider).apiBaseUrl);
  ref.onDispose(dio.close);
  return dio;
});

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(dioProvider)),
);

final serverHealthCheckProvider = Provider<ServerHealthCheck>((ref) {
  final probe = createHealthProbeDio(
    baseUrl: ref.watch(envProvider).apiBaseUrl,
  );
  ref.onDispose(probe.close);
  return ServerHealthCheck(probe);
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final probe = Dio();
  ref.onDispose(probe.close);
  return DeviceConnectivityService(
    probeClient: probe,
    probeUrl: ref.watch(envProvider).reachabilityUrl,
  );
});

// True while the internet is reachable. Starts as loading; screens treat
// "unknown" as online so the offline banner never flashes on launch.
final isOnlineProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).watchOnline(),
);
