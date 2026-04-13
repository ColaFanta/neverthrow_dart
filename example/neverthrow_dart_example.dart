import 'package:neverthrow_dart/neverthrow_dart.dart';

void main() async {
  // ── Result: fluent API ──────────────────────────────────────────────
  final age = parseAge('25')
      .map((a) => a + 1)
      .tap((a) => print('Next year you will be $a'))
      .flatMap((a) => divide(a, 2))
      .catchCase<FormatException>((e, _) => Result.ok(-1))
      .or(0);

  print('Half next age: $age'); // 13

  // ── Result: $do with $ ─────────────────────────────────────────────
  final result = $do(() {
    final a = parseAge('30').$;
    final b = divide(100, a).$;
    return 'Divided: $b';
  });

  print(result); // Ok('Divided: 3')

  // ── Option: fluent API ─────────────────────────────────────────────
  final greeting = Option.fromNullable({'name': 'Dart'}['name'])
      .map((n) => n.toUpperCase())
      .flatMap((n) => n.isEmpty ? Option.none() : Option.some('Hi, $n!'))
      .or('Hi, stranger!');

  print(greeting); // Hi, DART!

  // ── Option: $do with $ ─────────────────────────────────────────────
  final optResult = $do(() {
    final first = Option.fromNullable('Alice').$;
    final last = Option<String>.none().alt(() => Option.some('Smith')).$;
    return '$first $last';
  });

  print(optResult); // Ok('Alice Smith')

  // ── FutureResult: fluent API ───────────────────────────────────────
  final greetResult =
      await fetchGreeting('World').map((g) => g.toUpperCase()).tapErr((e, _) => print('Error: $e'));

  print(greetResult); // Ok('HELLO, WORLD!')

  // ── FutureResult: $doAsync with $ ──────────────────────────────────
  final asyncResult = await $doAsync(() async {
    final g = await fetchGreeting('Dart').$;
    final a = parseAge('10').$;
    return '$g (age: $a)';
  });

  print(asyncResult); // Ok('Hello, Dart! (age: 10)')

  // ── Error handling showcase ────────────────────────────────────────
  final recovered = parseAge('not_a_number')
      .tapErr((e, _) => print('Caught: $e'))
      .catchCase<FormatException>((e, _) => Result.ok(0))
      .map((a) => 'Age is $a');

  print(recovered); // Ok('Age is 0')
}

Result<int> parseAge(String input) =>
    Result.of(() => int.parse(input)).mapErr((e, _) => FormatException('Invalid age: $input'));

FutureResult<String> fetchGreeting(String name) =>
    Result.async(() => Future.delayed(const Duration(milliseconds: 50), () => 'Hello, $name!'));

Result<int> divide(int a, int b) =>
    b == 0 ? Result.err(Exception('Division by zero')) : Result.ok(a ~/ b);
