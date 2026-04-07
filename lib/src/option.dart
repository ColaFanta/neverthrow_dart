import 'package:freezed_annotation/freezed_annotation.dart';

import 'exceptions.dart';
import 'identity.dart';
import 'result.dart';

part 'option.freezed.dart';

/// Represents an optional value that is either present as `Some` or absent as
/// `None`.
@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none, fromJson: false, toJson: false)
sealed class Option<T> with _$Option<T> {
  const Option._();

  /// Unwraps the contained value or throws an internal bubble exception.
  ///
  /// This getter is intended for use inside [$do] and [$doAsync]. Outside
  /// those helpers, prefer [nullable], [or], [orElse], or [orThrow].
  T get $ => result.$;

  /// Returns the contained value or `null` when this option is empty.
  T? get nullable => switch (this) {
        Some<T>(:final val) => val,
        None<T>() => null,
      };

  /// Converts this option to a [Result].
  ///
  /// `Some` becomes `Ok`, while `None` becomes an `Err` containing
  /// [NeverThrowException.noSuchElement].
  Result<T> get result => switch (this) {
        Some<T>(:final val) => Result.ok(val),
        None<T>() => Result.err(NeverThrowException.noSuchElement(), StackTrace.current),
      };

  /// Whether this option contains a value.
  bool get isSome => switch (this) {
        Some<T>() => true,
        None<T>() => false,
      };

  /// Whether this option is empty.
  bool get isNone => switch (this) {
        Some<T>() => false,
        None<T>() => true,
      };

  /// Creates an option containing [val].
  factory Option.some(T val) = Some<T>;

  /// Creates an empty option.
  factory Option.none() = None<T>;

  /// Returns `Some` when [val] is a `T`, otherwise `None`.
  factory Option.cast(dynamic val) => Result<T>.cast(val).option;

  /// Returns `Some` for non-null values and `None` for `null`.
  factory Option.fromNullable(T? val) => val != null ? Some(val) : None();

  /// Creates a function that keeps values matching [predicate] as `Some`.
  static Option<T> Function(T) fromPredicate<T>(bool Function(T) predicate) =>
      (T val) => predicate(val) ? Some(val) : None();

  /// Creates a decoder from JSON object input to [Option].
  ///
  /// Invalid input or conversion failures become `None`.
  static Option<T> Function(Object?) jsonMap<T>(T Function(Map<String, dynamic>) convert) =>
      (Object? j) => Result.jsonMap(convert)(j).option;

  /// Creates a decoder from JSON list input to [Option].
  ///
  /// Invalid input or conversion failures become `None`.
  static Option<List<T>> Function(Object?) jsonList<T>(T Function(dynamic) convertOne) =>
      (Object? l) => Result.jsonList(convertOne)(l).option;

  /// Executes [fn] and wraps its returned value as an [Option].
  ///
  /// Exceptions are captured and returned as `None`.
  factory Option.of(T Function() fn) => Result.of(fn).option;

  /// Lifts [fn] so it returns [Option] and captures thrown exceptions.
  static Option<M> Function(T) ofK<M, T>(M Function(T) fn) => (val) => Option.of(() => fn(val));

  /// Returns the contained value or [or] when this option is empty.
  T or(T or) => switch (this) {
        Some(:final val) => val,
        None() => or,
      };

  /// Returns the contained value or the value produced by [fn] when empty.
  T orElse(T Function() fn) => switch (this) {
        Some(:final val) => val,
        None() => fn(),
      };

  /// Returns the contained value or throws the corresponding error.
  T get orThrow => result.orThrow;

  /// Returns this option when it is `Some`, otherwise evaluates [fn].
  Option<T> alt(Option<T> Function() fn) => switch (this) {
        Some(:final val) => Some(val),
        None() => fn(),
      };

  /// Transforms the contained value with [fn] when present.
  Option<M> map<M>(M Function(T) fn) => switch (this) {
        Some(:final val) => Some(fn(val)),
        None() => None(),
      };

  /// Attempts to cast the contained value to `M`.
  Option<M> cast<M>() => flatMap((val) => Option.cast(val));

  /// Chains another optional computation.
  Option<M> flatMap<M>(Option<M> Function(T) fn) => switch (this) {
        Some(:final val) => fn(val),
        None() => None(),
      };

  /// Chains a computation that may return `null`.
  Option<M> flatMapNullable<M>(M? Function(T) fn) => flatMap((val) => Option.fromNullable(fn(val)));

  /// Runs [fn] for side effects when a value is present.
  Option<T> tap(void Function(T) fn) => flatMap((val) {
        fn(val);
        return Some(val);
      });

  /// Removes one level of nesting from [m].
  factory Option.flatten(Option<Option<T>> m) => m.flatMap(identity);
}
