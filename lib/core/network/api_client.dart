import 'package:dio/dio.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/logger.dart';
import 'package:jdonuts/core/result.dart';

// Talks to the mock server's versioned API. Every response is wrapped in
// `{data, error, meta}`; this class unwraps it and turns transport errors
// into typed failures, so repositories never see a DioException.
class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Result<T>> get<T>(String path, T Function(Object? data) parse) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return _unwrap(response.data, parse);
    } on DioException catch (error, stackTrace) {
      logFailure('GET $path', error, stackTrace);
      return Err(_fromDio(error));
    } on Object catch (error, stackTrace) {
      // A malformed payload (TypeError, FormatException) is a server bug.
      logFailure('GET $path (parse)', error, stackTrace);
      return const Err(ServerFailure(statusCode: null, code: 'bad_payload'));
    }
  }

  Result<T> _unwrap<T>(
    Map<String, dynamic>? body,
    T Function(Object? data) parse,
  ) {
    if (body == null) {
      return const Err(ServerFailure(statusCode: null, code: 'empty_body'));
    }
    final error = body['error'];
    if (error is Map<String, dynamic>) {
      return Err(ServerFailure(statusCode: null, code: '${error['code']}'));
    }
    return Ok(parse(body['data']));
  }

  static Failure _fromDio(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => NetworkFailure(
        error.message ?? 'No connection',
      ),
      DioExceptionType.badResponse => ServerFailure(
        statusCode: error.response?.statusCode,
        code: _errorCode(error.response?.data),
      ),
      _ => UnexpectedFailure(error, error.stackTrace),
    };
  }

  static String _errorCode(Object? data) {
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) return '${error['code']}';
    }
    return 'http_error';
  }
}
