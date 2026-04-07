import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'do.dart';
import 'exceptions.dart';
import 'identity.dart';
import 'option.dart';
import 'result_async.dart';

part 'result.freezed.dart';

/// Represents either a successful value `Ok` or a failed value `Err`.
@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none, fromJson: false, toJson: false)
sealed class Result<T> with _$Result<T> {
  const Result._();

  /// Unwraps the successful value or throws an internal bubble exception.
  ///
  /// This getter is intended for use inside [$do] and [$doAsync]. Outside
  /// those helpers, prefer [nullable], [or], [orElse], or [orThrow].
  T get $ => switch (this) {
        Ok(:final val) => val,
        Err(:final e, stackTrace: final trace) => throw NeverThrowException.bubble(e, trace),
      };

  /// Returns the successful value or `null` when this result is an error.
  T? get nullable => switch (this) {
        Ok(:final val) => val,
        Err() => null,
      };

  /// Converts this result to an [Option], dropping error details on failure.
  Option<T> get option => switch (this) {
        Ok(:final val) => Option.some(val),
        Err() => Option.none(),
      };

  /// Whether this result is successful.
  bool get isOk => switch (this) {
        Ok() => true,
        Err() => false,
      };

  /// Whether this result is a failure.
  bool get isErr => switch (this) {
        Ok() => false,
        Err() => true,
      };

  /// Creates a successful result containing [val].
  factory Result.ok(T val) = Ok<T>;

  /// Creates a failed result containing [e] and an optional [stackTrace].
  factory Result.err(Exception e, [StackTrace? stackTrace]) = Err<T>;

  /// Returns `Ok` when [val] is a `T`, otherwise a cast-failure `Err`.
  factory Result.cast(dynamic val) => val is T
      ? Result.ok(val)
      : Result.err(NeverThrowException.castFailed(val, T), StackTrace.current);

  /// Converts a nullable value into `Ok` or `Err`.
  factory Result.fromNullable(T? val) => Option.fromNullable(val).result;

  /// Creates a validator that returns `Ok` for matching values and `Err`
  /// otherwise.
  ///
  /// When [e] is omitted, a [NeverThrowNoSuchElement] error is produced.
  static Result<T> Function(T) fromPredicate<T>(bool Function(T) predicate, [Exception? e]) =>
      (T val) => Option.fromPredicate(predicate)(val).result.mapErr((err, _) => e ?? err);

  /// Creates a JSON object decoder that returns a [Result].
  ///
  /// Errs:
  /// - [FormatException]
  /// - [CheckedFromJsonException]
  /// Errs:
  /// - [FormatException]
  /// - [CheckedFromJsonException]
  static Result<T> Function(Object?) jsonMap<T>(T Function(Map<String, dynamic>) convert) =>
      (Object? j) => $do(() {
            if (j is String) j = Result.of(() => jsonDecode(j as String)).$;

            if (j == null) return Result<T>.cast(j).$;

            final map = Result<Map<String, dynamic>>.cast(j).$;

            return Result.of(() => convert(map)).$;
          });

  /// Creates a JSON list decoder that returns a [Result].
  ///
  /// Errs:
  /// - [FormatException]
  /// - [CheckedFromJsonException]
  /// Errs:
  /// - [FormatException]
  /// - [CheckedFromJsonException]
  static Result<List<T>> Function(Object?) jsonList<T>(T Function(dynamic) convertOne) =>
      (Object? j) => $do(() {
            if (j is String) j = Result.of(() => jsonDecode(j as String)).$;

            if (j == null) return [];

            final list = Result<List>.cast(j).$;

            return Result.of(
              () => list.map((a) {
                if (a == null) return Result<T>.cast(a).orThrow;
                return convertOne(a);
              }).toList(),
            ).$;
          });

  /// Executes [fn] and converts thrown values into a [Result].
  ///
  /// [Exception] objects are preserved. Other thrown objects are wrapped in
  /// [NeverThrowException.unknown].
  factory Result.of(T Function() fn) {
    try {
      return Result.ok(fn());
    } on Exception catch (e, s) {
      return Result.err(e, s);
    } catch (e, s) {
      return Result.err(NeverThrowException.unknown(e), s);
    }
  }

  /// Lifts [fn] so it returns [Result] and captures thrown values.
  static Result<M> Function(T) ofK<M, T>(M Function(T) fn) => (val) => Result.of(() => fn(val));

  /// Awaits [val] and converts the outcome into a [FutureResult].
  static FutureResult<T> future<T>(Future<T> val) async {
    try {
      final v = await val;
      return Result.ok(v);
    } on Exception catch (e, s) {
      return Result.err(e, s);
    } catch (e, s) {
      return Result.err(NeverThrowException.unknown(e), s);
    }
  }

  /// Async version of [Result.of].
  static FutureResult<T> async<T>(Future<T> Function() fn) => future(fn());

  /// Lifts an async function so it returns [FutureResult].
  static FutureResult<M> Function(T) asyncK<M, T>(Future<M> Function(T) fn) =>
      (val) => async(() => fn(val));

  /// Returns the successful value or [or] when this result is an error.
  T or(T or) => switch (this) {
        Ok(:final val) => val,
        Err() => or,
      };

  /// Returns the successful value or computes a fallback with [fn].
  T orElse(T Function() fn) => switch (this) {
        Ok(:final val) => val,
        Err() => fn(),
      };

  /// Returns the successful value or throws the stored exception.
  ///
  /// If a stack trace was captured, it is preserved when rethrowing.
  T get orThrow => switch (this) {
        Ok(:final val) => val,
        Err(:final e, stackTrace: final trace) =>
          Error.throwWithStackTrace(e, trace ?? StackTrace.current),
      };

  /// Returns this result when it is `Ok`, otherwise evaluates [fn].
  Result<T> alt(Result<T> Function() fn) => switch (this) {
        Err() => fn(),
        _ => this,
      };

  /// Transforms the successful value with [fn].
  Result<M> map<M>(M Function(T) fn) => switch (this) {
        Ok(:final val) => Ok(fn(val)),
        Err(:final e, stackTrace: final trace) => Err(e, trace),
      };

  /// Attempts to cast the successful value to `M`.
  Result<M> cast<M>() => flatMap((a) => Result.cast(a));

  /// Transforms the error while preserving the success branch unchanged.
  Result<T> mapErr(Exception Function(Exception, StackTrace?) fn) => switch (this) {
        Err(:final e, stackTrace: final trace) => Err(fn(e, trace), trace),
        _ => this,
      };

  /// Transforms the error when it is of type `E`.
  Result<T> mapErrCase<E>(Exception Function(E, StackTrace?) fn) => switch (this) {
        Err(:final e, stackTrace: final trace) when e is E => Err(fn(e as E, trace), trace),
        _ => this,
      };

  /// Chains another fallible computation.
  Result<M> flatMap<M>(Result<M> Function(T) fn) => switch (this) {
        Ok(:final val) => fn(val),
        Err(:final e, stackTrace: final trace) => Err(e, trace),
      };

  /// Recovers from an error when [pred] matches.
  Result<T> catchIf(bool Function(Exception) pred, Result<T> Function(Exception, StackTrace?) fn) =>
      switch (this) {
        Err(:final e, stackTrace: final trace) when pred(e) => fn(e, trace),
        _ => this,
      };

  /// Recovers from an error when it is of type `E`.
  Result<T> catchCase<E>(Result<T> Function(E, StackTrace?) fn) => switch (this) {
        Err(:final e, stackTrace: final trace) when e is E => fn(e as E, trace),
        _ => this,
      };

  /// Recovers from any error.
  Result<T> catchAll(Result<T> Function(Exception, StackTrace?) fn) => switch (this) {
        Err(:final e, stackTrace: final trace) => fn(e, trace),
        _ => this,
      };

  /// Runs [fn] for side effects when this result is successful.
  Result<T> tap(void Function(T) fn) => flatMap((val) {
        fn(val);
        return this;
      });

  /// Runs [fn] for side effects when this result is an error.
  Result<T> tapErr(void Function(Exception, StackTrace?) fn) => catchAll((e, trace) {
        fn(e, trace);
        return this;
      });

  /// Removes one level of nesting from [m].
  factory Result.flatten(Result<Result<T>> m) => m.flatMap(identity);
}
