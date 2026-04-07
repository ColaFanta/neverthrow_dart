// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Option<T> {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Option<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Option<$T>()';
  }
}

/// @nodoc
class $OptionCopyWith<T, $Res> {
  $OptionCopyWith(Option<T> _, $Res Function(Option<T>) __);
}

/// @nodoc

class Some<T> extends Option<T> {
  Some(this.val) : super._();

  final T val;

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SomeCopyWith<T, Some<T>> get copyWith =>
      _$SomeCopyWithImpl<T, Some<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Some<T> &&
            const DeepCollectionEquality().equals(other.val, val));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(val));

  @override
  String toString() {
    return 'Option<$T>.some(val: $val)';
  }
}

/// @nodoc
abstract mixin class $SomeCopyWith<T, $Res>
    implements $OptionCopyWith<T, $Res> {
  factory $SomeCopyWith(Some<T> value, $Res Function(Some<T>) _then) =
      _$SomeCopyWithImpl;
  @useResult
  $Res call({T val});
}

/// @nodoc
class _$SomeCopyWithImpl<T, $Res> implements $SomeCopyWith<T, $Res> {
  _$SomeCopyWithImpl(this._self, this._then);

  final Some<T> _self;
  final $Res Function(Some<T>) _then;

  /// Create a copy of Option
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? val = freezed,
  }) {
    return _then(Some<T>(
      freezed == val
          ? _self.val
          : val // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class None<T> extends Option<T> {
  None() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is None<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'Option<$T>.none()';
  }
}

// dart format on
