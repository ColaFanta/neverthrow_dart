// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NeverThrowException {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NeverThrowException);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NeverThrowException()';
  }
}

/// @nodoc
class $NeverThrowExceptionCopyWith<$Res> {
  $NeverThrowExceptionCopyWith(
      NeverThrowException _, $Res Function(NeverThrowException) __);
}

/// Adds pattern-matching-related methods to [NeverThrowException].
extension NeverThrowExceptionPatterns on NeverThrowException {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeverThrowBubbleException value)? bubble,
    TResult Function(NeverThrowUnknownException value)? unknown,
    TResult Function(NeverThrowNoSuchElement value)? noSuchElement,
    TResult Function(NeverThrowCastFailed value)? castFailed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException() when bubble != null:
        return bubble(_that);
      case NeverThrowUnknownException() when unknown != null:
        return unknown(_that);
      case NeverThrowNoSuchElement() when noSuchElement != null:
        return noSuchElement(_that);
      case NeverThrowCastFailed() when castFailed != null:
        return castFailed(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeverThrowBubbleException value) bubble,
    required TResult Function(NeverThrowUnknownException value) unknown,
    required TResult Function(NeverThrowNoSuchElement value) noSuchElement,
    required TResult Function(NeverThrowCastFailed value) castFailed,
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException():
        return bubble(_that);
      case NeverThrowUnknownException():
        return unknown(_that);
      case NeverThrowNoSuchElement():
        return noSuchElement(_that);
      case NeverThrowCastFailed():
        return castFailed(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NeverThrowBubbleException value)? bubble,
    TResult? Function(NeverThrowUnknownException value)? unknown,
    TResult? Function(NeverThrowNoSuchElement value)? noSuchElement,
    TResult? Function(NeverThrowCastFailed value)? castFailed,
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException() when bubble != null:
        return bubble(_that);
      case NeverThrowUnknownException() when unknown != null:
        return unknown(_that);
      case NeverThrowNoSuchElement() when noSuchElement != null:
        return noSuchElement(_that);
      case NeverThrowCastFailed() when castFailed != null:
        return castFailed(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exception cause, StackTrace? trace)? bubble,
    TResult Function(Object cause)? unknown,
    TResult Function()? noSuchElement,
    TResult Function(dynamic src, Type target)? castFailed,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException() when bubble != null:
        return bubble(_that.cause, _that.trace);
      case NeverThrowUnknownException() when unknown != null:
        return unknown(_that.cause);
      case NeverThrowNoSuchElement() when noSuchElement != null:
        return noSuchElement();
      case NeverThrowCastFailed() when castFailed != null:
        return castFailed(_that.src, _that.target);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exception cause, StackTrace? trace) bubble,
    required TResult Function(Object cause) unknown,
    required TResult Function() noSuchElement,
    required TResult Function(dynamic src, Type target) castFailed,
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException():
        return bubble(_that.cause, _that.trace);
      case NeverThrowUnknownException():
        return unknown(_that.cause);
      case NeverThrowNoSuchElement():
        return noSuchElement();
      case NeverThrowCastFailed():
        return castFailed(_that.src, _that.target);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exception cause, StackTrace? trace)? bubble,
    TResult? Function(Object cause)? unknown,
    TResult? Function()? noSuchElement,
    TResult? Function(dynamic src, Type target)? castFailed,
  }) {
    final _that = this;
    switch (_that) {
      case NeverThrowBubbleException() when bubble != null:
        return bubble(_that.cause, _that.trace);
      case NeverThrowUnknownException() when unknown != null:
        return unknown(_that.cause);
      case NeverThrowNoSuchElement() when noSuchElement != null:
        return noSuchElement();
      case NeverThrowCastFailed() when castFailed != null:
        return castFailed(_that.src, _that.target);
      case _:
        return null;
    }
  }
}

/// @nodoc

class NeverThrowBubbleException extends NeverThrowException {
  NeverThrowBubbleException(this.cause, [this.trace]) : super._();

  final Exception cause;
  final StackTrace? trace;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NeverThrowBubbleExceptionCopyWith<NeverThrowBubbleException> get copyWith =>
      _$NeverThrowBubbleExceptionCopyWithImpl<NeverThrowBubbleException>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NeverThrowBubbleException &&
            (identical(other.cause, cause) || other.cause == cause) &&
            (identical(other.trace, trace) || other.trace == trace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cause, trace);

  @override
  String toString() {
    return 'NeverThrowException.bubble(cause: $cause, trace: $trace)';
  }
}

/// @nodoc
abstract mixin class $NeverThrowBubbleExceptionCopyWith<$Res>
    implements $NeverThrowExceptionCopyWith<$Res> {
  factory $NeverThrowBubbleExceptionCopyWith(NeverThrowBubbleException value,
          $Res Function(NeverThrowBubbleException) _then) =
      _$NeverThrowBubbleExceptionCopyWithImpl;
  @useResult
  $Res call({Exception cause, StackTrace? trace});
}

/// @nodoc
class _$NeverThrowBubbleExceptionCopyWithImpl<$Res>
    implements $NeverThrowBubbleExceptionCopyWith<$Res> {
  _$NeverThrowBubbleExceptionCopyWithImpl(this._self, this._then);

  final NeverThrowBubbleException _self;
  final $Res Function(NeverThrowBubbleException) _then;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cause = null,
    Object? trace = freezed,
  }) {
    return _then(NeverThrowBubbleException(
      null == cause
          ? _self.cause
          : cause // ignore: cast_nullable_to_non_nullable
              as Exception,
      freezed == trace
          ? _self.trace
          : trace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class NeverThrowUnknownException extends NeverThrowException {
  NeverThrowUnknownException(this.cause) : super._();

  final Object cause;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NeverThrowUnknownExceptionCopyWith<NeverThrowUnknownException>
      get copyWith =>
          _$NeverThrowUnknownExceptionCopyWithImpl<NeverThrowUnknownException>(
              this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NeverThrowUnknownException &&
            const DeepCollectionEquality().equals(other.cause, cause));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(cause));

  @override
  String toString() {
    return 'NeverThrowException.unknown(cause: $cause)';
  }
}

/// @nodoc
abstract mixin class $NeverThrowUnknownExceptionCopyWith<$Res>
    implements $NeverThrowExceptionCopyWith<$Res> {
  factory $NeverThrowUnknownExceptionCopyWith(NeverThrowUnknownException value,
          $Res Function(NeverThrowUnknownException) _then) =
      _$NeverThrowUnknownExceptionCopyWithImpl;
  @useResult
  $Res call({Object cause});
}

/// @nodoc
class _$NeverThrowUnknownExceptionCopyWithImpl<$Res>
    implements $NeverThrowUnknownExceptionCopyWith<$Res> {
  _$NeverThrowUnknownExceptionCopyWithImpl(this._self, this._then);

  final NeverThrowUnknownException _self;
  final $Res Function(NeverThrowUnknownException) _then;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cause = null,
  }) {
    return _then(NeverThrowUnknownException(
      null == cause ? _self.cause : cause,
    ));
  }
}

/// @nodoc

class NeverThrowNoSuchElement extends NeverThrowException {
  NeverThrowNoSuchElement() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is NeverThrowNoSuchElement);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'NeverThrowException.noSuchElement()';
  }
}

/// @nodoc

class NeverThrowCastFailed extends NeverThrowException {
  NeverThrowCastFailed(this.src, this.target) : super._();

  final dynamic src;
  final Type target;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NeverThrowCastFailedCopyWith<NeverThrowCastFailed> get copyWith =>
      _$NeverThrowCastFailedCopyWithImpl<NeverThrowCastFailed>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NeverThrowCastFailed &&
            const DeepCollectionEquality().equals(other.src, src) &&
            (identical(other.target, target) || other.target == target));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(src), target);

  @override
  String toString() {
    return 'NeverThrowException.castFailed(src: $src, target: $target)';
  }
}

/// @nodoc
abstract mixin class $NeverThrowCastFailedCopyWith<$Res>
    implements $NeverThrowExceptionCopyWith<$Res> {
  factory $NeverThrowCastFailedCopyWith(NeverThrowCastFailed value,
          $Res Function(NeverThrowCastFailed) _then) =
      _$NeverThrowCastFailedCopyWithImpl;
  @useResult
  $Res call({dynamic src, Type target});
}

/// @nodoc
class _$NeverThrowCastFailedCopyWithImpl<$Res>
    implements $NeverThrowCastFailedCopyWith<$Res> {
  _$NeverThrowCastFailedCopyWithImpl(this._self, this._then);

  final NeverThrowCastFailed _self;
  final $Res Function(NeverThrowCastFailed) _then;

  /// Create a copy of NeverThrowException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? src = freezed,
    Object? target = null,
  }) {
    return _then(NeverThrowCastFailed(
      freezed == src
          ? _self.src
          : src // ignore: cast_nullable_to_non_nullable
              as dynamic,
      null == target
          ? _self.target
          : target // ignore: cast_nullable_to_non_nullable
              as Type,
    ));
  }
}

// dart format on
