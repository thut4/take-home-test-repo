import 'dart:async';

import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/logger.dart';
import 'package:jdonuts/core/result.dart';

// Wraps a database watch stream so every emission is a [Result]: values
// become [Ok], errors are logged and become [Err] with a [CacheFailure]
// (or the failure itself, if the query threw one).
Stream<Result<T>> watchResult<T>(String where, Stream<T> source) {
  return source.transform(
    StreamTransformer<T, Result<T>>.fromHandlers(
      handleData: (value, sink) => sink.add(Ok(value)),
      handleError: (error, stackTrace, sink) {
        logFailure(where, error, stackTrace);
        sink.add(Err(error is Failure ? error : CacheFailure('$error')));
      },
    ),
  );
}
