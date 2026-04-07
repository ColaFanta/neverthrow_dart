import 'package:neverthrow_dart/neverthrow_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should not bubble error when run sync', () {
    final result = $do(() {
      final num1 = Option.some(42).$;
      final num2 = Option.some(20).$;
      final num3 = Option<int>.none().orElse(() => 20);

      return num1 + num2 + num3;
    });

    expect(result, isA<Ok<int>>());
    expect(result.$, 82);
  });

  test('should catch a bubbled error when \$ none', () {
    final result = $do(() {
      final num1 = Option.some(42).$;
      final num2 = Option<int>.none().$; // This will throw
      return num1 + num2;
    });

    expect(result, isA<Err<int>>());
    expect(() => result.$, throwsA(isA<NeverThrowBubbleException>()));
  });

  test('should not bubble error when run result', () async {
    final result = await $doAsync(() async {
      final s = Result.ok('sync value').$;
      final r = await Result.future(Future<int>.value(42)).$;

      return '$s and $r';
    });

    final ok = result.orThrow;

    expect(ok, 'sync value and 42');
  });

  test('should catch a bubbled error when \$ err in async', () async {
    final result = await $doAsync(() async {
      final s = Result.ok('sync value').$;
      final r = await Result.future(Future<int>.value(42)).$;
      final n = Result<String>.err(NeverThrowException.noSuchElement()).$; // This will throw

      return '$s and $r and $n';
    });

    expect(result, isA<Err<String>>());
    expect(() => result.$, throwsA(isA<NeverThrowBubbleException>()));
  });
}
