// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TestState {
  int get integer => throw _privateConstructorUsedError;
  String get string => throw _privateConstructorUsedError;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TestStateCopyWith<TestState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestStateCopyWith<$Res> {
  factory $TestStateCopyWith(TestState value, $Res Function(TestState) then) =
      _$TestStateCopyWithImpl<$Res, TestState>;
  @useResult
  $Res call({int integer, String string});
}

/// @nodoc
class _$TestStateCopyWithImpl<$Res, $Val extends TestState>
    implements $TestStateCopyWith<$Res> {
  _$TestStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? integer = null,
    Object? string = null,
  }) {
    return _then(_value.copyWith(
      integer: null == integer
          ? _value.integer
          : integer // ignore: cast_nullable_to_non_nullable
              as int,
      string: null == string
          ? _value.string
          : string // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestStateImplCopyWith<$Res>
    implements $TestStateCopyWith<$Res> {
  factory _$$TestStateImplCopyWith(
          _$TestStateImpl value, $Res Function(_$TestStateImpl) then) =
      __$$TestStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int integer, String string});
}

/// @nodoc
class __$$TestStateImplCopyWithImpl<$Res>
    extends _$TestStateCopyWithImpl<$Res, _$TestStateImpl>
    implements _$$TestStateImplCopyWith<$Res> {
  __$$TestStateImplCopyWithImpl(
      _$TestStateImpl _value, $Res Function(_$TestStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? integer = null,
    Object? string = null,
  }) {
    return _then(_$TestStateImpl(
      integer: null == integer
          ? _value.integer
          : integer // ignore: cast_nullable_to_non_nullable
              as int,
      string: null == string
          ? _value.string
          : string // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TestStateImpl extends _TestState {
  const _$TestStateImpl({this.integer = 0, this.string = ''}) : super._();

  @override
  @JsonKey()
  final int integer;
  @override
  @JsonKey()
  final String string;

  @override
  String toString() {
    return 'TestState(integer: $integer, string: $string)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestStateImpl &&
            (identical(other.integer, integer) || other.integer == integer) &&
            (identical(other.string, string) || other.string == string));
  }

  @override
  int get hashCode => Object.hash(runtimeType, integer, string);

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TestStateImplCopyWith<_$TestStateImpl> get copyWith =>
      __$$TestStateImplCopyWithImpl<_$TestStateImpl>(this, _$identity);
}

abstract class _TestState extends TestState {
  const factory _TestState({final int integer, final String string}) =
      _$TestStateImpl;
  const _TestState._() : super._();

  @override
  int get integer;
  @override
  String get string;

  /// Create a copy of TestState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TestStateImplCopyWith<_$TestStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
