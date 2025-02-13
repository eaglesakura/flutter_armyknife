// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mutable_state_stream_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MutableStateStreamState<T> {
  /// ライフサイクル.
  MutableStateStreamLifecycle get lifecycle =>
      throw _privateConstructorUsedError;

  /// 現在の値
  T get state => throw _privateConstructorUsedError;

  /// 開放関数.
  Future<dynamic> Function(T) get dispose => throw _privateConstructorUsedError;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MutableStateStreamStateCopyWith<T, MutableStateStreamState<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MutableStateStreamStateCopyWith<T, $Res> {
  factory $MutableStateStreamStateCopyWith(MutableStateStreamState<T> value,
          $Res Function(MutableStateStreamState<T>) then) =
      _$MutableStateStreamStateCopyWithImpl<T, $Res,
          MutableStateStreamState<T>>;
  @useResult
  $Res call(
      {MutableStateStreamLifecycle lifecycle,
      T state,
      Future<dynamic> Function(T) dispose});
}

/// @nodoc
class _$MutableStateStreamStateCopyWithImpl<T, $Res,
        $Val extends MutableStateStreamState<T>>
    implements $MutableStateStreamStateCopyWith<T, $Res> {
  _$MutableStateStreamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifecycle = null,
    Object? state = freezed,
    Object? dispose = null,
  }) {
    return _then(_value.copyWith(
      lifecycle: null == lifecycle
          ? _value.lifecycle
          : lifecycle // ignore: cast_nullable_to_non_nullable
              as MutableStateStreamLifecycle,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as T,
      dispose: null == dispose
          ? _value.dispose
          : dispose // ignore: cast_nullable_to_non_nullable
              as Future<dynamic> Function(T),
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MutableStateStreamStateImplCopyWith<T, $Res>
    implements $MutableStateStreamStateCopyWith<T, $Res> {
  factory _$$MutableStateStreamStateImplCopyWith(
          _$MutableStateStreamStateImpl<T> value,
          $Res Function(_$MutableStateStreamStateImpl<T>) then) =
      __$$MutableStateStreamStateImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {MutableStateStreamLifecycle lifecycle,
      T state,
      Future<dynamic> Function(T) dispose});
}

/// @nodoc
class __$$MutableStateStreamStateImplCopyWithImpl<T, $Res>
    extends _$MutableStateStreamStateCopyWithImpl<T, $Res,
        _$MutableStateStreamStateImpl<T>>
    implements _$$MutableStateStreamStateImplCopyWith<T, $Res> {
  __$$MutableStateStreamStateImplCopyWithImpl(
      _$MutableStateStreamStateImpl<T> _value,
      $Res Function(_$MutableStateStreamStateImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifecycle = null,
    Object? state = freezed,
    Object? dispose = null,
  }) {
    return _then(_$MutableStateStreamStateImpl<T>(
      lifecycle: null == lifecycle
          ? _value.lifecycle
          : lifecycle // ignore: cast_nullable_to_non_nullable
              as MutableStateStreamLifecycle,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as T,
      dispose: null == dispose
          ? _value.dispose
          : dispose // ignore: cast_nullable_to_non_nullable
              as Future<dynamic> Function(T),
    ));
  }
}

/// @nodoc

class _$MutableStateStreamStateImpl<T> extends _MutableStateStreamState<T> {
  const _$MutableStateStreamStateImpl(
      {this.lifecycle = MutableStateStreamLifecycle.alive,
      required this.state,
      required this.dispose})
      : super._();

  /// ライフサイクル.
  @override
  @JsonKey()
  final MutableStateStreamLifecycle lifecycle;

  /// 現在の値
  @override
  final T state;

  /// 開放関数.
  @override
  final Future<dynamic> Function(T) dispose;

  @override
  String toString() {
    return 'MutableStateStreamState<$T>(lifecycle: $lifecycle, state: $state, dispose: $dispose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MutableStateStreamStateImpl<T> &&
            (identical(other.lifecycle, lifecycle) ||
                other.lifecycle == lifecycle) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            (identical(other.dispose, dispose) || other.dispose == dispose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lifecycle,
      const DeepCollectionEquality().hash(state), dispose);

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MutableStateStreamStateImplCopyWith<T, _$MutableStateStreamStateImpl<T>>
      get copyWith => __$$MutableStateStreamStateImplCopyWithImpl<T,
          _$MutableStateStreamStateImpl<T>>(this, _$identity);
}

abstract class _MutableStateStreamState<T> extends MutableStateStreamState<T> {
  const factory _MutableStateStreamState(
          {final MutableStateStreamLifecycle lifecycle,
          required final T state,
          required final Future<dynamic> Function(T) dispose}) =
      _$MutableStateStreamStateImpl<T>;
  const _MutableStateStreamState._() : super._();

  /// ライフサイクル.
  @override
  MutableStateStreamLifecycle get lifecycle;

  /// 現在の値
  @override
  T get state;

  /// 開放関数.
  @override
  Future<dynamic> Function(T) get dispose;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MutableStateStreamStateImplCopyWith<T, _$MutableStateStreamStateImpl<T>>
      get copyWith => throw _privateConstructorUsedError;
}
