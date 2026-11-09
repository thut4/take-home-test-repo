import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:jdonuts/core/failure.dart';

// Asks the mock server whether it is up before a batch of API calls, so a
// stopped server costs one quiet request and one log line instead of a
// retried, logged failure for every endpoint.
class ServerHealthCheck {
  ServerHealthCheck(this._probe);

  static const _path = '/v1/health';

  final Dio _probe;

  // Returns the failure when the server can't be reached, or null when it
  // is up.
  Future<Failure?> check() async {
    try {
      await _probe.get<String>(_path);
      return null;
    } on DioException catch (error) {
      final message =
          'Mock server not reachable at ${_probe.options.baseUrl} '
          '(${error.type.name}); keeping local data';
      developer.log(message, name: 'jdonuts');
      return NetworkFailure(message);
    }
  }
}
