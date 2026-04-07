import 'package:freezed_annotation/freezed_annotation.dart';

part 'exceptions.freezed.dart';

/// Internal exception types used to implement neverthrow control flow.
///
/// These are exposed so callers can pattern-match or transform failures, but
/// most code will interact with them through [Result] and [Option] instead of
/// constructing them directly.
@freezed
sealed class NeverThrowException with _$NeverThrowException implements Exception {
  NeverThrowException._();

  /// Wraps an existing exception so `$do`/`$doAsync` can bubble failures.
  factory NeverThrowException.bubble(Exception cause, [StackTrace? trace]) =
      NeverThrowBubbleException;

  /// Wraps a non-[Exception] throwable caught by [Result.of] or [Result.future].
  factory NeverThrowException.unknown(Object cause) = NeverThrowUnknownException;

  /// Indicates that a value was requested from an empty [Option].
  factory NeverThrowException.noSuchElement() = NeverThrowNoSuchElement;

  /// Indicates that a runtime cast to [target] failed for [src].
  factory NeverThrowException.castFailed(dynamic src, Type target) = NeverThrowCastFailed;
}
