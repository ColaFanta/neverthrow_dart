import 'dart:async';

import 'identity.dart';
import 'option.dart';
import 'result.dart';

/// Convenience alias for an asynchronous [Result].
typedef FutureResult<T> = Future<Result<T>>;

/// Async combinators for [FutureResult].
extension FutureResultExt<T> on FutureResult<T> {
  /// Unwraps the successful value or rethrows the stored failure.
  ///
  /// This is primarily useful inside [$doAsync].
  Future<T> get $ => then((a) => a.$);

  /// Resolves to the successful value or `null` on error.
  Future<T?> get nullable => then((a) => a.nullable);

  /// Converts the async result into an async [Option].
  Future<Option<T>> get option => then((a) => a.option);

  /// Whether the resolved result is successful.
  Future<bool> get isOk => then((a) => a.isOk);

  /// Whether the resolved result is a failure.
  Future<bool> get isErr => then((a) => a.isErr);

  /// Returns the successful value or awaits [or] as a fallback.
  Future<T> or(Future<T> or) => then((a) async {
        final val = await or;
        return a.or(val);
      });

  /// Returns the successful value or computes an async fallback with [fn].
  Future<T> orElse(FutureOr<T> Function() fn) => then((a) async {
        final or = await fn();
        return a.or(or);
      });

  /// Returns the successful value or throws the stored exception.
  Future<T> get orThrow => then((a) => a.orThrow);

  /// Returns this future result when it resolves to `Ok`, otherwise evaluates [fn].
  FutureResult<T> alt(FutureResult<T> Function(Exception) fn) => then(
        (a) async => switch (a) {
          Ok(:final val) => Ok(val),
          Err(:final e) => await fn(e),
        },
      );

  /// Transforms the successful value with [fn].
  FutureResult<M> map<M>(FutureOr<M> Function(T) fn) => then(
        (a) async => switch (a) {
          Ok(:final val) => Ok(await fn(val)),
          Err(:final e, stackTrace: final trace) => Err(e, trace),
        },
      );

  /// Attempts to cast the successful value to `M`.
  FutureResult<M> cast<M>() => flatMap(Result.cast);

  /// Transforms the error while preserving the success branch unchanged.
  FutureResult<T> mapErr(FutureOr<Exception> Function(Exception, StackTrace?) fn) => then(
        (a) async => switch (a) {
          Err(:final e, stackTrace: final trace) => Err(await fn(e, trace), trace),
          _ => a,
        },
      );

  /// Transforms the error when [pred] matches.
  FutureResult<T> mapErrIf(
    FutureOr<bool> Function(Exception) pred,
    FutureOr<Exception> Function(Exception, StackTrace?) fn,
  ) =>
      then(
        (a) async => switch (a) {
          Err(:final e, stackTrace: final trace) when await pred(e) =>
            Err(await fn(e, trace), trace),
          _ => a,
        },
      );

  /// Transforms the error when it is of type `E`.
  FutureResult<T> mapErrCase<E>(FutureOr<Exception> Function(E, StackTrace?) fn) => then(
        (a) async => switch (a) {
          Err(:final e, stackTrace: final trace) when e is E => Err(await fn(e as E, trace), trace),
          _ => a,
        },
      );

  /// Chains another async or sync fallible computation.
  FutureResult<M> flatMap<M>(FutureOr<Result<M>> Function(T) fn) => then(
        (a) => switch (a) {
          Ok(:final val) => fn(val),
          Err(:final e, stackTrace: final trace) => Err(e, trace),
        },
      );

  /// Recovers from an error when [pred] matches.
  FutureResult<T> catchIf(
    FutureOr<bool> Function(Exception) pred,
    FutureOr<Result<T>> Function(Exception, StackTrace?) fn,
  ) =>
      then(
        (a) async => switch (a) {
          Err(:final e, stackTrace: final trace) when await pred(e) => fn(e, trace),
          _ => a,
        },
      );

  /// Recovers from an error when it is of type `E`.
  FutureResult<T> catchCase<E>(FutureOr<Result<T>> Function(E, StackTrace?) fn) => then(
        (a) => switch (a) {
          Err(:final e, stackTrace: final trace) when e is E => fn(e as E, trace),
          _ => a,
        },
      );

  /// Recovers from any error.
  FutureResult<T> catchAll(FutureOr<Result<T>> Function(Exception, StackTrace?) fn) => then(
        (a) => switch (a) {
          Err(:final e, stackTrace: final trace) => fn(e, trace),
          _ => a,
        },
      );

  /// Runs [fn] for side effects when the result is successful.
  FutureResult<T> tap(FutureOr<void> Function(T) fn) => flatMap((val) async {
        await fn(val);
        return Ok(val);
      });

  /// Runs [fn] for side effects when the result is an error.
  FutureResult<T> tapErr(FutureOr<void> Function(Exception, StackTrace?) fn) =>
      catchAll((e, trace) async {
        await fn(e, trace);
        return Err(e, trace);
      });

  /// Runs [fn] for side effects when the error matches [pred].
  FutureResult<T> tapErrIf(
    FutureOr<bool> Function(Exception) pred,
    FutureOr<void> Function(Exception, StackTrace?) fn,
  ) =>
      catchIf(pred, (e, trace) async {
        await fn(e, trace);
        return Err(e, trace);
      });

  /// Runs [fn] for side effects when the error is of type `E`.
  FutureResult<T> tapErrCase<E extends Exception>(FutureOr<void> Function(E, StackTrace?) fn) =>
      catchCase<E>((e, trace) async {
        await fn(e, trace);
        return Err(e, trace);
      });

  /// Removes one level of nesting from [asyncRes].
  static FutureResult<T> flatten<T>(FutureResult<FutureResult<T>> asyncRes) =>
      asyncRes.flatMap(identity);
}
