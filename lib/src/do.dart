import 'dart:async';

import 'exceptions.dart';
import 'result.dart';
import 'result_async.dart';

/// Executes [fn] and returns its value as a [Result].
///
/// Inside [fn], accessing [Result.$] or [Option.$] can short-circuit the block
/// by throwing an internal [NeverThrowBubbleException], which is caught and
/// converted back into an `Err`.
Result<T> $do<T>(T Function() fn) {
  try {
    return Result.ok(fn());
  } on NeverThrowBubbleException catch (e) {
    return Result.err(e.cause, e.trace);
  }
}

/// Async variant of [$do] for composing `Future<Result<T>>` flows.
///
/// Any bubbled neverthrow failure is caught and returned as an `Err` while
/// successful values are wrapped in `Ok`.
FutureResult<T> $doAsync<T>(FutureOr<T> Function() fn) async {
  try {
    final val = await fn();
    return Result.ok(val);
  } on NeverThrowBubbleException catch (e) {
    return Result.err(e.cause, e.trace);
  }
}
