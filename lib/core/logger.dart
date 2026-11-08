import 'dart:developer' as developer;

// Thin logging hook so failures are recorded, never swallowed.
void logFailure(String where, Object error, [StackTrace? stackTrace]) {
  developer.log(
    'Failure in $where',
    name: 'jdonuts',
    error: error,
    stackTrace: stackTrace,
  );
}
