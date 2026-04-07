// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Result<T> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Result<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Result<$T>()';
  }
}

/// @nodoc
class $ResultCopyWith<T, $Res> {
  $ResultCopyWith(Result<T> _, $Res Function(Result<T>) __);
}

/// @nodoc

class Ok<T> extends Result<T> {
  Ok(this.val) : super._();

  final T val;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OkCopyWith<T, Ok<T>> get copyWith =>
      _$OkCopyWithImpl<T, Ok<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Ok<T> &&
            const DeepCollectionEquality().equals(other.val, val));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(val));

  @override
  String toString() {
    return 'Result<$T>.ok(val: $val)';
  }
}

/// @nodoc
abstract mixin class $OkCopyWith<T, $Res> implements $ResultCopyWith<T, $Res> {
  factory $OkCopyWith(Ok<T> value, $Res Function(Ok<T>) _then) =
      _$OkCopyWithImpl;
  @useResult
  $Res call({T val});
}

/// @nodoc
class _$OkCopyWithImpl<T, $Res> implements $OkCopyWith<T, $Res> {
  _$OkCopyWithImpl(this._self, this._then);

  final Ok<T> _self;
  final $Res Function(Ok<T>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? val = freezed,
  }) {
    return _then(Ok<T>(
      freezed == val
          ? _self.val
          : val // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class Err<T> extends Result<T> {
  Err(this.e, [this.stackTrace]) : super._();

  final Exception e;
  final StackTrace? stackTrace;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrCopyWith<T, Err<T>> get copyWith =>
      _$ErrCopyWithImpl<T, Err<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Err<T> &&
            (identical(other.e, e) || other.e == e) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, e, stackTrace);

  @override
  String toString() {
    return 'Result<$T>.err(e: $e, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $ErrCopyWith<T, $Res> implements $ResultCopyWith<T, $Res> {
  factory $ErrCopyWith(Err<T> value, $Res Function(Err<T>) _then) =
      _$ErrCopyWithImpl;
  @useResult
  $Res call({Exception e, StackTrace? stackTrace});
}

/// @nodoc
class _$ErrCopyWithImpl<T, $Res> implements $ErrCopyWith<T, $Res> {
  _$ErrCopyWithImpl(this._self, this._then);

  final Err<T> _self;
  final $Res Function(Err<T>) _then;

  /// Create a copy of Result
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? e = null,
    Object? stackTrace = freezed,
  }) {
    return _then(Err<T>(
      null == e
          ? _self.e
          : e // ignore: cast_nullable_to_non_nullable
              as Exception,
      freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
