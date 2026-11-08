// Base of every typed failure. Features add their own sealed families
// (for example `AuthFailure`); the UI maps each type to a message.
abstract class Failure implements Exception {
  const Failure();

  // Developer-facing detail for logs. Never shown to users.
  String get debugMessage;

  @override
  String toString() => '$runtimeType: $debugMessage';
}

// The device is offline, or the request timed out.
final class NetworkFailure extends Failure {
  const NetworkFailure([this.debugMessage = 'No connection']);

  @override
  final String debugMessage;
}

// The server answered with an error envelope or an unexpected status.
final class ServerFailure extends Failure {
  const ServerFailure({required this.statusCode, this.code = 'unknown'});

  final int? statusCode;
  final String code;

  @override
  String get debugMessage => 'HTTP $statusCode ($code)';
}

// Reading or writing the local database failed.
final class CacheFailure extends Failure {
  const CacheFailure(this.debugMessage);

  @override
  final String debugMessage;
}

// The requested record doesn't exist locally.
final class NotFoundFailure extends Failure {
  const NotFoundFailure(this.debugMessage);

  @override
  final String debugMessage;
}

// Anything else. Wraps the original error so it is never swallowed.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(this.error, [this.stackTrace]);

  final Object error;
  final StackTrace? stackTrace;

  @override
  String get debugMessage => '$error';
}
