// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestState {
  int get integer;
  String get string;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestStateCopyWith<TestState> get copyWith =>
      _$TestStateCopyWithImpl<TestState>(this as TestState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestState &&
            (identical(other.integer, integer) || other.integer == integer) &&
            (identical(other.string, string) || other.string == string));
  }

  @override
  int get hashCode => Object.hash(runtimeType, integer, string);

  @override
  String toString() {
    return 'TestState(integer: $integer, string: $string)';
  }
}

/// @nodoc
abstract mixin class $TestStateCopyWith<$Res> {
  factory $TestStateCopyWith(TestState value, $Res Function(TestState) _then) =
      _$TestStateCopyWithImpl;
  @useResult
  $Res call({int integer, String string});
}

/// @nodoc
class _$TestStateCopyWithImpl<$Res> implements $TestStateCopyWith<$Res> {
  _$TestStateCopyWithImpl(this._self, this._then);

  final TestState _self;
  final $Res Function(TestState) _then;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? integer = null,
    Object? string = null,
  }) {
    return _then(_self.copyWith(
      integer: null == integer
          ? _self.integer
          : integer // ignore: cast_nullable_to_non_nullable
              as int,
      string: null == string
          ? _self.string
          : string // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _TestState extends TestState {
  const _TestState({this.integer = 0, this.string = ''}) : super._();

  @override
  @JsonKey()
  final int integer;
  @override
  @JsonKey()
  final String string;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestStateCopyWith<_TestState> get copyWith =>
      __$TestStateCopyWithImpl<_TestState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestState &&
            (identical(other.integer, integer) || other.integer == integer) &&
            (identical(other.string, string) || other.string == string));
  }

  @override
  int get hashCode => Object.hash(runtimeType, integer, string);

  @override
  String toString() {
    return 'TestState(integer: $integer, string: $string)';
  }
}

/// @nodoc
abstract mixin class _$TestStateCopyWith<$Res>
    implements $TestStateCopyWith<$Res> {
  factory _$TestStateCopyWith(
          _TestState value, $Res Function(_TestState) _then) =
      __$TestStateCopyWithImpl;
  @override
  @useResult
  $Res call({int integer, String string});
}

/// @nodoc
class __$TestStateCopyWithImpl<$Res> implements _$TestStateCopyWith<$Res> {
  __$TestStateCopyWithImpl(this._self, this._then);

  final _TestState _self;
  final $Res Function(_TestState) _then;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? integer = null,
    Object? string = null,
  }) {
    return _then(_TestState(
      integer: null == integer
          ? _self.integer
          : integer // ignore: cast_nullable_to_non_nullable
              as int,
      string: null == string
          ? _self.string
          : string // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
