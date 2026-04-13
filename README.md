# neverthrow_dart

[![pub package](https://img.shields.io/pub/v/neverthrow_dart.svg)](https://pub.dev/packages/neverthrow_dart)
[![pub likes](https://img.shields.io/pub/likes/neverthrow_dart)](https://pub.dev/packages/neverthrow_dart/score)
[![pub points](https://img.shields.io/pub/points/neverthrow_dart)](https://pub.dev/packages/neverthrow_dart/score)
[![license](https://img.shields.io/github/license/ColaFanta/neverthrow_dart)](https://github.com/ColaFanta/neverthrow_dart/blob/main/LICENSE)

Brings better error handling to Dart, with `Result`, `Option`, `FutureResult`, and `do`-style composition.

## Introduction

### Description

`neverthrow_dart` provides functional primitives that make failures explicit and composable.

- Use `Result<T>` when an operation can succeed or fail.
- Use `Option<T>` when a value may be absent and you do not want to model that with `null`.
- Use `FutureResult<T>` when a fallible workflow is asynchronous.

The goal is not to ban `throw`. It is to make expected failure visible in the type system.

### Installation

CLI:

```bash
dart pub add neverthrow_dart
```

For Flutter:

```bash
flutter pub add neverthrow_dart
```

Manual `pubspec.yaml`:

```yaml
dependencies:
  neverthrow_dart: ^<latest version>
```

Latest version: [![pub package](https://img.shields.io/pub/v/neverthrow_dart.svg?label=pub.dev)](https://pub.dev/packages/neverthrow_dart)

### About this project

- The name `neverthrow` is a slogan, not a rule. You should still throw when it is the right tool.
- This package is not a direct Dart port of the TypeScript [`neverthrow`](https://github.com/supermacro/neverthrow).
- It follows the same idea, but the API is shaped for Dart 3, Dart exceptions, and real Flutter usage.

### Why use `Result`

`Result` fits Dart well, especially with sealed classes and pattern matching in Dart 3.

The main benefit is that failure becomes part of the function signature:

- callers can see that an operation may fail before reading the implementation
- success and failure can be transformed with `map`, `flatMap`, `mapErr`, and recovery APIs
- intermediate layers can pass failures upward without broad `try` / `catch` blocks
- code becomes easier to test because both branches are regular values

Flutter's own architecture guide also recommends the pattern: [Result pattern](https://docs.flutter.dev/app-architecture/design-patterns/result).

For example:

```dart
User parseUserWithThrow(String raw) {
  final json = jsonDecode(raw) as Map<String, dynamic>;
  return User.fromJson(json);
}

Result<User> parseUser(String raw) {
  return Result.of(() {
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return User.fromJson(json);
  });
}
```

The second version makes failure explicit and leaves recovery to the caller.

### Why `neverthrow_dart`

In practice, a minimal self-implemented `Result` type is usually not enough. Although there are already similar ideas and `Result`-like packages on `pub.dev`, many of them are either too heavyweight or lack some pieces, so I end up using several at the same time, which makes my code inconsistent and bloated. So I decided to make one that focuses on error handling, with the minimum necessary utility functions, shaped for Dart 3.

#### Immutability and equality

Without value semantics, a `Result` type becomes awkward in tests and state updates:

```dart
final class MyResult<T> {
  T? value;
  Exception? error;

  MyResult.ok(this.value) : error = null;
  MyResult.err(this.error) : value = null;
}

final a = MyResult.ok(42);
final b = MyResult.ok(42);

print(a == b); // false
```

Two equal success values are still different objects.

`neverthrow_dart` makes `Result` and `Option` immutable value types:

```dart
final a = Result.ok(42);
final b = Result.ok(42);

print(a == b); // true
```
#### Stack trace concern

Dart separates `Exception` and `StackTrace`, but many `Result` packages only keep the exception:

```dart
final class SimpleErr<T> {
  final Exception error;

  SimpleErr(this.error);
}
```

That loses the original stack trace.

`Err` in `neverthrow_dart` stores both. Recovery APIs keep that data, and `orThrow` rethrows with the original trace.

```dart
final result = Result.of(() => int.parse('not-a-number'));

result.tapErr((error, trace) {
  logger.severe('Parsing failed', error, trace);
});

// If you choose to throw at the boundary, the original trace is preserved.
final value = result.orThrow;
```

#### Better composition and conciseness

##### Less unwrap boilerplate

Many popular `Result` packages on `pub.dev` usually ask you to unwrap with `fold`, `match`, or a similar API before you can keep using the success value.

That often looks like this:

```dart
Result<String> buildServiceLabel(Map<String, dynamic> env) {
  return Result.tryOf(() => env['SERVICE_NAME']).fold(
    (serviceNameValue) => Result.tryOf(() => serviceNameValue as String).fold(
      (serviceName) => Result.tryOf(() => env['PORT']).fold(
        (portValue) => Result.tryOf(() => portValue as String).fold(
          (portString) => Result.tryOf(() => int.parse(portString)).fold(
            (port) => port > 0
                ? Success('${serviceName.trim()}:${port + 1000}')
                : Failure(Exception('Port must be positive')),
            (error) => Failure(error),
          ),
          (error) => Failure(error),
        ),
        (error) => Failure(error),
      ),
      (error) => Failure(error),
    ),
    (error) => Failure(error),
  );
}
```

`neverthrow_dart` supports fluent transforms too, but it also adds `$do` notation when you want to use the value directly:

```dart
Result<String> buildServiceLabel(Map<String, dynamic> env) {
  return $do(() {
    final serviceName = Result<String>.cast(env['SERVICE_NAME']).$.trim();
    final rawPort = Result<String>.cast(env['PORT']).$;
    final port = Result.of(() => int.parse(rawPort)).$;

    if (port <= 0) return Result<String>.err(Exception('Port must be positive')).$;

    return '$serviceName:${port + 1000}';
  });
}
```

The flow reads like normal Dart, and failure still bubbles as `Result`.

##### Sync and async compose the same way

Many packages split sync and async into different types such as `Result` and `AsyncResult`. Once sync and async code meet, you usually have to convert between them explicitly.

That often looks like this:

```dart
Future<AsyncResult<UserCard, Exception>> loadUserCard(String id) async {
  final userResponse = await api.fetchUser(id);
  final userAsync = AsyncResult.fromResult(parseUserJson(userResponse));

  return userAsync.flatMap((user) async {
    final avatarResponse = await cdn.fetchAvatar(user.avatarId);
    final avatarAsync = AsyncResult.fromResult(parseAvatarJson(avatarResponse));

    return avatarAsync.map((avatar) {
      final displayName = user.nickname != null && user.nickname!.trim().isNotEmpty
          ? user.nickname!.trim()
          : user.name;

      return UserCard(
        id: user.id,
        displayName: displayName,
        avatarUrl: avatar.url,
        lastSeenLabel: formatLastSeen(user.lastSeenAt),
      );
    });
  });
}
```

In `neverthrow_dart`, both sync and async flows are still just `Result`. Async is simply `Future<Result<T>>`, with the same operations available on top:

```dart
FutureResult<UserCard> loadUserCard(String id) {
  return $doAsync(() async {
    final userResponse = await Result.async(() => api.fetchUser(id)).$;
    final user = parseUserJson(userResponse).$;
    final avatarResponse = await Result.async(() => cdn.fetchAvatar(user.avatarId)).$;
    final avatar = parseAvatarJson(avatarResponse).$;

    final displayName = Option.fromNullable(user.nickname)
        .map((name) => name.trim())
        .flatMapNullable((name) => name.isEmpty ? null : name)
        .or(user.name);

    return UserCard(
      id: user.id,
      displayName: displayName,
      avatarUrl: avatar.url,
      lastSeenLabel: formatLastSeen(user.lastSeenAt),
    );
  });
}
```

No extra result type, no explicit conversion, and sync `Result` code composes directly inside async flows.


### Why `Result<T>` instead of `Result<T, E>`

This package uses `Result<T>` rather than `Result<T, E>`.

In TypeScript, a typed error channel works well because the language can express unions ergonomically:

```ts
declare function readFile(path: string): Result<string, FileNotFoundError | PermissionDeniedError>
declare function parseConfig(raw: string): Result<Config, ParseError>

declare function loadConfig(path: string): Result<Config, FileNotFoundError | PermissionDeniedError | ParseError>
```

Dart does not have an equivalent union type for errors. In practice, `Result<T, E>` often leads to these tradeoffs:

- widen everything to a shared supertype early, losing the precision you wanted
- manually unwrap and re-wrap results whenever two different error types need to compose
- build your own sealed error hierarchy for every flow, even when it is not worth the ceremony

The hypothetical `Result<T, E>` version is usually more like this, where every layer has to unwrap and convert error types again:

```dart
// Hypothetical API, not this package.
Result<String, ReadConfigError> readConfigText(String path) {
  final fileResult = readFile(path);

  return switch (fileResult) {
    Ok(:final val) => Ok(val),
    Err(:final error) => Err(ReadConfigFileError(error)),
  };
}

Result<Config, LoadConfigError> parseConfigFile(String path) {
  final textResult = readConfigText(path);

  return switch (textResult) {
    Ok(:final text) {
      final parsed = parseConfig(text);

      return switch (parsed) {
        Ok(:final config) => Ok(config),
        Err(:final error) => Err(LoadConfigParseError(error)), // needs to convert error here
      };
    }
    Err(:final error) => Err(LoadConfigReadError(error)),
  };
}

Result<App, BootstrapError> bootstrapApp(String path) {
  final configResult = parseConfigFile(path);

  return switch (configResult) {
    Ok(:final config) {
      final appResult = buildApp(config);

      return switch (appResult) {
        Ok(:final app) => Ok(app),
        Err(:final error) => Err(BootstrapBuildError(error)), // needs to convert error here
      };
    }
    Err(:final error) => Err(BootstrapConfigError(error)), // needs to convert error here
  };
}

void runBootstrap(String path) {
  final result = bootstrapApp(path);

  switch (result) {
    case Ok(:final val):
      print('App started: $val');
    case Err(:final error) when error is BootstrapConfigError:
      print('Config failed: ${error.cause}');
    case Err(:final error) when error is BootstrapBuildError:
      print('Build failed: ${error.cause}');
    case Err(:final error):
      print('Unknown bootstrap failure: $error');
  }
}
```
`neverthrow_dart` takes the pragmatic middle ground: `Err` always contains an `Exception`, and you can still recover by concrete type with `catchCase` and `mapErrCase`. The flow can stay this small:
```dart
Result<Config> loadConfig(String path) {
  return $do(() {
    final raw = readFile(path).$;
    return parseConfig(raw).$;
  });
}

void bootstrap(String path) {
  loadConfig(path)
      .catchCase<FormatException>((error, trace) {
        print('Config format is invalid: $error');
        return Result.err(error, trace);
      })
      .catchAll((error, trace) {
        print('Failed to load config: $error');
        return Result.err(error, trace);
      });
}
```
That keeps composition simple while still allowing typed handling when needed.

As a compromise, it is recommended to document your error types in Dart doc comments so that later error-handling logic can easily know which exceptions to handle.

### `do` notation

Pipelines are good for straight-line transforms, but sometimes direct style is clearer.

That is what `$do` and `$doAsync` are for.

Inside a `$do` block, `.$` unwraps a `Result` or `Option`, or bubbles failure to the nearest `$do`.

```dart
Result<int> sumThreeNumbers() {
  return $do(() {
    final a = Result.ok(40).$;
    final b = Option.some(2).$;
    final c = Result<int>.fromNullable(10).$;

    return a + b + c;
  });
}
```

If any step fails, the block returns `Err`.

```dart
Result<User> loadCurrentUser(Session? session) {
  return $do(() {
    final currentSession = Result.fromNullable(session).$;
    final userId = currentSession.userId;
    final raw = readUserJson(userId).$;

    return Result.jsonMap(User.fromJson)(raw).$;
  });
}
```

There is an async version too:

```dart
FutureResult<User> loadCurrentUserAsync(Session? session) {
  return $doAsync(() async {
    final currentSession = Result.fromNullable(session).$;
    final raw = await Result.async(() => api.fetchUser(currentSession.userId)).$;

    return Result.jsonMap(User.fromJson)(raw).$;
  });
}
```

This gives you early-return style without using unchecked exceptions for control flow.

### What's more in `neverthrow_dart`

- `Option<T>` for presence / absence without `null`
- `FutureResult<T>` extensions for fluent async composition
- `Result.of` and `Result.async` to capture exceptions from sync and async code
- `fromNullable`, `fromPredicate`, and `cast` helpers
- `tap`, `tapErr`, and typed variants for side effects without breaking pipelines
- `catchAll`, `catchIf`, and `catchCase` for recovery
- JSON decoding helpers for objects and lists
- `flatten` helpers for nested `Result`, `FutureResult`, and `Option`

Example:

```dart
final title = Option.fromNullable(payload['title'] as String?)
    .map((value) => value.trim())
    .flatMapNullable((value) => value.isEmpty ? null : value)
    .or('Untitled');
```

## How to use

Jump to a section:

- [Basic `Result`](#basic-result)
- [Transforming values](#transforming-values)
- [Recovering from failures](#recovering-from-failures)
- [Async workflows with `FutureResult`](#async-workflows-with-futureresult)
- [Using `Option`](#using-option)
- [Using `$do` and `$doAsync`](#using-do-and-doasync)
- [JSON helpers](#json-helpers)

### Basic `Result`

Create success and failure values directly:

```dart
final ok = Result.ok('hello');
final err = Result<String>.err(Exception('Something went wrong'));

print(ok.isOk); // true
print(err.isErr); // true
```

Capture exceptions from existing code:

```dart
Result<int> parseInt(String raw) {
  return Result.of(() => int.parse(raw));
}
```

Pattern-match when it is the clearest form:

```dart
switch (parseInt('42')) {
  case Ok(:final val):
    print('Parsed: $val');
  case Err(:final e):
    print('Failed: $e');
}
```

### Transforming values

Use `map` to transform values and `flatMap` when the next step can also fail.

```dart
Result<int> parsePositiveInt(String raw) {
  return Result.of(() => int.parse(raw))
      .flatMap(Result.fromPredicate<int>((value) => value > 0, Exception('Must be positive')));
}

final doubled = parsePositiveInt('21').map((value) => value * 2);
```

`mapErr` transforms the error side:

```dart
final result = Result.of(() => int.parse('abc')).mapErr((error, trace) {
  return Exception('Input is not a valid integer: $error');
});
```

### Recovering from failures

Use `catchAll` when any exception should be handled:

```dart
final fallback = Result.of(() => int.parse('abc')).catchAll((error, trace) {
  return Result.ok(0);
});
```

Use `catchCase` to recover by type:

```dart
final safeNumber = Result.of(() => int.parse('abc')).catchCase<FormatException>((error, trace) {
  return Result.ok(0);
});
```

Use `or` and `orElse` for fallback values:

```dart
final value = Result<int>.err(Exception('boom')).or(10);
final lazyValue = Result<int>.err(Exception('boom')).orElse(() => 10);
```

### Async workflows with `FutureResult`

Wrap a throwing future with `Result.async` or an existing `Future<T>` with `Result.future`.

```dart
FutureResult<int> fetchCounter() {
  return Result.async(() => api.fetchCounter())
      .map((value) => value + 1)
      .catchCase<TimeoutException>((error, trace) => Result.ok(0));
}
```

The async extensions mirror the sync API:

```dart
final result = await Result.async(() => api.fetchUser('42'))
    .map((json) => User.fromJson(json))
    .tap((user) => logger.info('Loaded ${user.id}'))
    .tapErr((error, trace) => logger.warning('Fetch failed', error, trace));
```

### Using `Option`

Use `Option<T>` when absence is expected and not exceptional.

```dart
Option<String> findDisplayName(Map<String, dynamic> json) {
  return Option.fromNullable(json['displayName'] as String?)
      .map((value) => value.trim())
      .flatMapNullable((value) => value.isEmpty ? null : value);
}
```

Convert between `Option` and `Result` when needed:

```dart
final option = Option.fromNullable(user.nickname);
final result = option.result;
final backToOption = result.option;
```

### Using `$do` and `$doAsync`

Use `.$` inside `$do` / `$doAsync` for fail-fast logic in direct style.

```dart
Result<String> buildGreeting(Map<String, dynamic> json) {
  return $do(() {
    final name = Option.fromNullable(json['name'] as String?).$;
    final age = Result.of(() => json['age'] as int).$;

    return 'Hello $name, age $age';
  });
}
```

Async version:

```dart
FutureResult<String> loadGreeting(String id) {
  return $doAsync(() async {
    final profile = await Result.async(() => api.fetchProfile(id)).$;
    final name = Option.fromNullable(profile['name'] as String?).$;

    return 'Hello $name';
  });
}
```

### JSON helpers

Decode an object with `Result.jsonMap`:

```dart
final userResult = Result.jsonMap(User.fromJson)('{"id":1,"name":"Ada"}');
```

Decode a list with `Result.jsonList`:

```dart
final usersResult = Result.jsonList((json) => User.fromJson(json))([
  {'id': 1, 'name': 'Ada'},
  {'id': 2, 'name': 'Grace'},
]);
```

There are `Option` equivalents too:

```dart
final maybeUser = Option.jsonMap(User.fromJson)(rawJson);
final maybeUsers = Option.jsonList((json) => User.fromJson(json))(rawList);
```

## API overview

Main constructors and helpers:

- `Result.ok(value)`
- `Result.err(exception, [stackTrace])`
- `Result.of(() => value)`
- `Result.async(() async => value)`
- `Result.future(future)`
- `Result.fromNullable(value)`
- `Result.fromPredicate(predicate, [exception])`
- `Result.cast(value)`
- `Result.jsonMap(fromJson)`
- `Result.jsonList(fromJson)`
- `Option.some(value)`
- `Option.none()`
- `Option.fromNullable(value)`
- `Option.fromPredicate(predicate)`
- `$do(() { ... })`
- `$doAsync(() async { ... })`

Core instance methods:

- `map`
- `flatMap`
- `mapErr`
- `mapErrCase`
- `catchAll`
- `catchIf`
- `catchCase`
- `tap`
- `tapErr`
- `alt`
- `or`
- `orElse`
- `orThrow`

## Philosophy

`neverthrow_dart` is built around a simple idea:

- model expected failure as data
- keep composition easy
- preserve stack traces
- let callers decide where to recover and where to throw

If that matches how you write Dart and Flutter code, this package should feel natural.