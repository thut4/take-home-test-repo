import 'package:jdonuts/core/failure.dart';
import 'package:meta/meta.dart';

// Outcome of an operation that can fail. Repositories and use cases return
// it instead of throwing, so every caller handles both cases.
sealed class Result<T> {
  const Result();

  // The value, or null on failure.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  // The failure, or null on success.
  Failure? get failureOrNull => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };

  // The value, or throws the failure. For stream providers, where Riverpod
  // turns the throw into an AsyncError the UI renders.
  T getOrThrow() => switch (this) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };

  // Transforms the value, keeping a failure as it is.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok(:final value) => Ok(transform(value)),
    Err(:final failure) => Err(failure),
  };
}

@immutable
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

@immutable
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) => other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}

// The unit value for `Result<Unit>`, for operations with no result value.
final class Unit {
  const Unit._();
}

const unit = Unit._();
