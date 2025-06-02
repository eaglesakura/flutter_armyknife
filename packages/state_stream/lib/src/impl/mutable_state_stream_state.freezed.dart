// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mutable_state_stream_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MutableStateStreamState<T> {
  /// ライフサイクル.
  MutableStateStreamLifecycle get lifecycle;

  /// 現在の値
  T get state;

  /// 開放関数.
  Future Function(T state) get onClose;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MutableStateStreamStateCopyWith<T, MutableStateStreamState<T>>
      get copyWith =>
          _$MutableStateStreamStateCopyWithImpl<T, MutableStateStreamState<T>>(
              this as MutableStateStreamState<T>, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MutableStateStreamState<T> &&
            (identical(other.lifecycle, lifecycle) ||
                other.lifecycle == lifecycle) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            (identical(other.onClose, onClose) || other.onClose == onClose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lifecycle,
      const DeepCollectionEquality().hash(state), onClose);

  @override
  String toString() {
    return 'MutableStateStreamState<$T>(lifecycle: $lifecycle, state: $state, onClose: $onClose)';
  }
}

/// @nodoc
abstract mixin class $MutableStateStreamStateCopyWith<T, $Res> {
  factory $MutableStateStreamStateCopyWith(MutableStateStreamState<T> value,
          $Res Function(MutableStateStreamState<T>) _then) =
      _$MutableStateStreamStateCopyWithImpl;
  @useResult
  $Res call(
      {MutableStateStreamLifecycle lifecycle,
      T state,
      Future Function(T state) onClose});
}

/// @nodoc
class _$MutableStateStreamStateCopyWithImpl<T, $Res>
    implements $MutableStateStreamStateCopyWith<T, $Res> {
  _$MutableStateStreamStateCopyWithImpl(this._self, this._then);

  final MutableStateStreamState<T> _self;
  final $Res Function(MutableStateStreamState<T>) _then;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lifecycle = null,
    Object? state = freezed,
    Object? onClose = null,
  }) {
    return _then(_self.copyWith(
      lifecycle: null == lifecycle
          ? _self.lifecycle
          : lifecycle // ignore: cast_nullable_to_non_nullable
              as MutableStateStreamLifecycle,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as T,
      onClose: null == onClose
          ? _self.onClose
          : onClose // ignore: cast_nullable_to_non_nullable
              as Future Function(T state),
    ));
  }
}

/// @nodoc

class _MutableStateStreamState<T> extends MutableStateStreamState<T> {
  const _MutableStateStreamState(
      {this.lifecycle = MutableStateStreamLifecycle.alive,
      required this.state,
      required this.onClose})
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
  final Future Function(T state) onClose;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MutableStateStreamStateCopyWith<T, _MutableStateStreamState<T>>
      get copyWith => __$MutableStateStreamStateCopyWithImpl<T,
          _MutableStateStreamState<T>>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MutableStateStreamState<T> &&
            (identical(other.lifecycle, lifecycle) ||
                other.lifecycle == lifecycle) &&
            const DeepCollectionEquality().equals(other.state, state) &&
            (identical(other.onClose, onClose) || other.onClose == onClose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lifecycle,
      const DeepCollectionEquality().hash(state), onClose);

  @override
  String toString() {
    return 'MutableStateStreamState<$T>(lifecycle: $lifecycle, state: $state, onClose: $onClose)';
  }
}

/// @nodoc
abstract mixin class _$MutableStateStreamStateCopyWith<T, $Res>
    implements $MutableStateStreamStateCopyWith<T, $Res> {
  factory _$MutableStateStreamStateCopyWith(_MutableStateStreamState<T> value,
          $Res Function(_MutableStateStreamState<T>) _then) =
      __$MutableStateStreamStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MutableStateStreamLifecycle lifecycle,
      T state,
      Future Function(T state) onClose});
}

/// @nodoc
class __$MutableStateStreamStateCopyWithImpl<T, $Res>
    implements _$MutableStateStreamStateCopyWith<T, $Res> {
  __$MutableStateStreamStateCopyWithImpl(this._self, this._then);

  final _MutableStateStreamState<T> _self;
  final $Res Function(_MutableStateStreamState<T>) _then;

  /// Create a copy of MutableStateStreamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lifecycle = null,
    Object? state = freezed,
    Object? onClose = null,
  }) {
    return _then(_MutableStateStreamState<T>(
      lifecycle: null == lifecycle
          ? _self.lifecycle
          : lifecycle // ignore: cast_nullable_to_non_nullable
              as MutableStateStreamLifecycle,
      state: freezed == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as T,
      onClose: null == onClose
          ? _self.onClose
          : onClose // ignore: cast_nullable_to_non_nullable
              as Future Function(T state),
    ));
  }
}

// dart format on
