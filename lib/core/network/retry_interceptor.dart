import 'package:dio/dio.dart';

// Retries idempotent GET requests that failed on the transport (timeouts,
// dropped connections) or with a 5xx, backing off between attempts.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxRetries = defaultMaxRetries,
    this.baseDelay = defaultBaseDelay,
  });

  static const defaultMaxRetries = 2;
  static const defaultBaseDelay = Duration(milliseconds: 400);
  static const _attemptKey = 'retry_attempt';
  static const _serverErrorFloor = 500;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;
    if (!_shouldRetry(err) || attempt >= maxRetries) {
      return handler.next(err);
    }
    await Future<void>.delayed(baseDelay * (attempt + 1));
    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException err) {
    if (err.requestOptions.method != 'GET') return false;
    return switch (err.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => true,
      DioExceptionType.badResponse =>
        (err.response?.statusCode ?? 0) >= _serverErrorFloor,
      _ => false,
    };
  }
}
