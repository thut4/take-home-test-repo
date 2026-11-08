import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

// Whether the app can reach the internet right now.
abstract interface class ConnectivityService {
  // Emits the current status first, then every change.
  Stream<bool> watchOnline();

  Future<bool> checkOnline();
}

// connectivity_plus only says a network interface is up; a captive portal
// or a dead Wi-Fi still looks "connected". So every change is confirmed
// with a real request ([probeUrl]), and the status is re-checked on a
// timer to notice recovery the plugin doesn't report.
class DeviceConnectivityService implements ConnectivityService {
  DeviceConnectivityService({
    required Dio probeClient,
    required this.probeUrl,
    Connectivity? connectivity,
    this.recheckInterval = defaultRecheckInterval,
  }) : _probe = probeClient,
       _connectivity = connectivity ?? Connectivity();

  static const defaultRecheckInterval = Duration(seconds: 15);
  static const _probeTimeout = Duration(seconds: 3);
  static const _okStatusLimit = 400;

  final Dio _probe;
  final Connectivity _connectivity;
  final String probeUrl;
  final Duration recheckInterval;

  @override
  Stream<bool> watchOnline() {
    late final StreamController<bool> controller;
    StreamSubscription<List<ConnectivityResult>>? subscription;
    Timer? timer;
    bool? last;

    Future<void> emit() async {
      final online = await checkOnline();
      if (online != last && !controller.isClosed) controller.add(online);
      last = online;
    }

    controller = StreamController<bool>(
      onListen: () {
        unawaited(emit());
        subscription = _connectivity.onConnectivityChanged.listen(
          (_) => unawaited(emit()),
        );
        timer = Timer.periodic(recheckInterval, (_) => unawaited(emit()));
      },
      onCancel: () async {
        timer?.cancel();
        await subscription?.cancel();
      },
    );
    return controller.stream;
  }

  @override
  Future<bool> checkOnline() async {
    final interfaces = await _connectivity.checkConnectivity();
    if (interfaces.every((r) => r == ConnectivityResult.none)) return false;
    return await _reachable();
  }

  Future<bool> _reachable() async {
    try {
      final response = await _probe.get<void>(
        probeUrl,
        options: Options(
          receiveTimeout: _probeTimeout,
          sendTimeout: _probeTimeout,
          validateStatus: (_) => true,
        ),
      );
      return (response.statusCode ?? _okStatusLimit) < _okStatusLimit;
    } on DioException {
      // Unreachable is the expected offline outcome, not an error.
      return false;
    }
  }
}
