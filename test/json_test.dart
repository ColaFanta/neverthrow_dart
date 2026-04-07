import 'dart:convert';

import 'package:neverthrow_dart/neverthrow_dart.dart';
import 'package:test/test.dart';

void main() {
  test('should be able to decode string json', () {
    final sample = '{"value":"test"}';

    final decode = Result.jsonMap(SampleJsonStruct.fromJson)(sample);
    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isA<SampleJsonStruct>());
    expect(decode.orThrow.value, equals('test'));

    final encoded = jsonEncode(decode.orThrow);
    expect(encoded, equals(sample));
  });

  test('should be able to decode Map', () {
    final sampleMap = {'value': 'test'};
    final decode = Result.jsonMap(SampleJsonStruct.fromJson)(sampleMap);
    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isA<SampleJsonStruct>());
    expect(decode.orThrow.value, equals('test'));
  });

  test('should be able to decode List', () {
    final sampleList = [
      {'value': 'test1'},
      {'value': 'test2'},
    ];

    final decode = Result.jsonList((j) => SampleJsonStruct.fromJson(j))(sampleList);

    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isA<List<SampleJsonStruct>>());
    expect(decode.orThrow.length, equals(2));
    expect(decode.orThrow[0].value, equals('test1'));
    expect(decode.orThrow[1].value, equals('test2'));
  });

  test('should be able to decode List of Primitive types', () {
    final sampleList = [1, 2, 3, 4, 5];

    final decode = Result.jsonList((j) => j as int)(sampleList);

    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isA<List<int>>());
    expect(decode.orThrow.length, equals(5));
    expect(decode.orThrow[0], equals(1));
    expect(decode.orThrow[4], equals(5));
  });

  test('should be able to decode list of null', () {
    final decode = Result.jsonList<SampleJsonStruct?>((j) => SampleJsonStruct.fromJson(j))([
      null,
      {'value': 'test'},
      null,
    ]);

    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isA<List<SampleJsonStruct?>>());
    expect(decode.orThrow.length, equals(3));
    expect(decode.orThrow[0], isNull);
    expect(decode.orThrow[1]?.value, equals('test'));
    expect(decode.orThrow[2], isNull);
  });

  test('should throw when decode list of null while target type is non-nullable', () {
    final decode = Result.jsonList<SampleJsonStruct>((j) => SampleJsonStruct.fromJson(j))([
      null,
      {'value': 'test'},
      null,
    ]);

    expect(decode.isErr, isTrue);
    expect(() => decode.orThrow, throwsA(isA<NeverThrowCastFailed>()));
  });

  test('should be able to decode null', () {
    final decode = Result.jsonMap<SampleJsonStruct?>(SampleJsonStruct.fromJson)(null);

    expect(decode.isOk, isTrue);
    expect(decode.orThrow, isNull);
  });

  test('should throw when decode null while target type is non-nullable', () {
    final decode = Result.jsonMap<SampleJsonStruct>(SampleJsonStruct.fromJson)(null);

    expect(decode.isErr, isTrue);
    expect(() => decode.orThrow, throwsA(isA<NeverThrowCastFailed>()));
  });
}

final class SampleJsonStruct {
  final String value;

  SampleJsonStruct({required this.value});

  factory SampleJsonStruct.fromJson(Map<String, dynamic> json) {
    return SampleJsonStruct(value: json['value'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'value': value};
  }
}
