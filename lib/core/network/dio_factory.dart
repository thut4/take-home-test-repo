import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jdonuts/core/network/retry_interceptor.dart';

// Network timeouts. Short, because the app always has local data to show.
abstract final class NetworkTimeouts {
  static const connect = Duration(seconds: 4);
  static const receive = Duration(seconds: 6);
  static const send = Duration(seconds: 4);
}

/// Dio configured with timeouts, retry and (in debug builds) logging.
Dio createDio({required String baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: NetworkTimeouts.connect,
      receiveTimeout: NetworkTimeouts.receive,
      sendTimeout: NetworkTimeouts.send,
      headers: const {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(RetryInterceptor(dio));
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        logPrint: (line) => developer.log('$line', name: 'jdonuts.http'),
      ),
    );
  }
  return dio;
}

/// Dio for the server health check: no retry and no logging, so a stopped
/// server fails once and silently. The body is not parsed; only the status
/// matters.
Dio createHealthProbeDio({required String baseUrl}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: NetworkTimeouts.connect,
      receiveTimeout: NetworkTimeouts.receive,
      responseType: ResponseType.plain,
    ),
  );
}
