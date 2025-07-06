// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'future_context_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FutureContextRequest {
  /// デバッグ出力時のStackの戻る量を指定する.
  int get debugCallStackLevel;

  /// Create a copy of FutureContextRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FutureContextRequestCopyWith<FutureContextRequest> get copyWith =>
      _$FutureContextRequestCopyWithImpl<FutureContextRequest>(
          this as FutureContextRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FutureContextRequest &&
            (identical(other.debugCallStackLevel, debugCallStackLevel) ||
                other.debugCallStackLevel == debugCallStackLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, debugCallStackLevel);

  @override
  String toString() {
    return 'FutureContextRequest(debugCallStackLevel: $debugCallStackLevel)';
  }
}

/// @nodoc
abstract mixin class $FutureContextRequestCopyWith<$Res> {
  factory $FutureContextRequestCopyWith(FutureContextRequest value,
          $Res Function(FutureContextRequest) _then) =
      _$FutureContextRequestCopyWithImpl;
  @useResult
  $Res call({int debugCallStackLevel});
}

/// @nodoc
class _$FutureContextRequestCopyWithImpl<$Res>
    implements $FutureContextRequestCopyWith<$Res> {
  _$FutureContextRequestCopyWithImpl(this._self, this._then);

  final FutureContextRequest _self;
  final $Res Function(FutureContextRequest) _then;

  /// Create a copy of FutureContextRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? debugCallStackLevel = null,
  }) {
    return _then(_self.copyWith(
      debugCallStackLevel: null == debugCallStackLevel
          ? _self.debugCallStackLevel
          : debugCallStackLevel // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _FutureContextRequest implements FutureContextRequest {
  const _FutureContextRequest({this.debugCallStackLevel = 0});

  /// デバッグ出力時のStackの戻る量を指定する.
  @override
  @JsonKey()
  final int debugCallStackLevel;

  /// Create a copy of FutureContextRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FutureContextRequestCopyWith<_FutureContextRequest> get copyWith =>
      __$FutureContextRequestCopyWithImpl<_FutureContextRequest>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FutureContextRequest &&
            (identical(other.debugCallStackLevel, debugCallStackLevel) ||
                other.debugCallStackLevel == debugCallStackLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, debugCallStackLevel);

  @override
  String toString() {
    return 'FutureContextRequest(debugCallStackLevel: $debugCallStackLevel)';
  }
}

/// @nodoc
abstract mixin class _$FutureContextRequestCopyWith<$Res>
    implements $FutureContextRequestCopyWith<$Res> {
  factory _$FutureContextRequestCopyWith(_FutureContextRequest value,
          $Res Function(_FutureContextRequest) _then) =
      __$FutureContextRequestCopyWithImpl;
  @override
  @useResult
  $Res call({int debugCallStackLevel});
}

/// @nodoc
class __$FutureContextRequestCopyWithImpl<$Res>
    implements _$FutureContextRequestCopyWith<$Res> {
  __$FutureContextRequestCopyWithImpl(this._self, this._then);

  final _FutureContextRequest _self;
  final $Res Function(_FutureContextRequest) _then;

  /// Create a copy of FutureContextRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? debugCallStackLevel = null,
  }) {
    return _then(_FutureContextRequest(
      debugCallStackLevel: null == debugCallStackLevel
          ? _self.debugCallStackLevel
          : debugCallStackLevel // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
