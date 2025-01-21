// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localized_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LocalizedText {
  /// 所属しているPackage.
  DartPackage get dartPackage => throw _privateConstructorUsedError;

  /// メッセージを一意に識別するためのID.
  String get id => throw _privateConstructorUsedError;

  /// 出力されるメッセージ.
  Map<String, String> get text => throw _privateConstructorUsedError;

  /// メッセージ引数.
  List<String> get placeHolders => throw _privateConstructorUsedError;

  /// メッセージの説明.
  String? get description => throw _privateConstructorUsedError;

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalizedTextCopyWith<LocalizedText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalizedTextCopyWith<$Res> {
  factory $LocalizedTextCopyWith(
          LocalizedText value, $Res Function(LocalizedText) then) =
      _$LocalizedTextCopyWithImpl<$Res, LocalizedText>;
  @useResult
  $Res call(
      {DartPackage dartPackage,
      String id,
      Map<String, String> text,
      List<String> placeHolders,
      String? description});
}

/// @nodoc
class _$LocalizedTextCopyWithImpl<$Res, $Val extends LocalizedText>
    implements $LocalizedTextCopyWith<$Res> {
  _$LocalizedTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dartPackage = null,
    Object? id = null,
    Object? text = null,
    Object? placeHolders = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      dartPackage: null == dartPackage
          ? _value.dartPackage
          : dartPackage // ignore: cast_nullable_to_non_nullable
              as DartPackage,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      placeHolders: null == placeHolders
          ? _value.placeHolders
          : placeHolders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocalizedTextImplCopyWith<$Res>
    implements $LocalizedTextCopyWith<$Res> {
  factory _$$LocalizedTextImplCopyWith(
          _$LocalizedTextImpl value, $Res Function(_$LocalizedTextImpl) then) =
      __$$LocalizedTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DartPackage dartPackage,
      String id,
      Map<String, String> text,
      List<String> placeHolders,
      String? description});
}

/// @nodoc
class __$$LocalizedTextImplCopyWithImpl<$Res>
    extends _$LocalizedTextCopyWithImpl<$Res, _$LocalizedTextImpl>
    implements _$$LocalizedTextImplCopyWith<$Res> {
  __$$LocalizedTextImplCopyWithImpl(
      _$LocalizedTextImpl _value, $Res Function(_$LocalizedTextImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dartPackage = null,
    Object? id = null,
    Object? text = null,
    Object? placeHolders = null,
    Object? description = freezed,
  }) {
    return _then(_$LocalizedTextImpl(
      dartPackage: null == dartPackage
          ? _value.dartPackage
          : dartPackage // ignore: cast_nullable_to_non_nullable
              as DartPackage,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value._text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      placeHolders: null == placeHolders
          ? _value._placeHolders
          : placeHolders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LocalizedTextImpl extends _LocalizedText {
  _$LocalizedTextImpl(
      {required this.dartPackage,
      required this.id,
      required final Map<String, String> text,
      required final List<String> placeHolders,
      this.description})
      : _text = text,
        _placeHolders = placeHolders,
        super._();

  /// 所属しているPackage.
  @override
  final DartPackage dartPackage;

  /// メッセージを一意に識別するためのID.
  @override
  final String id;

  /// 出力されるメッセージ.
  final Map<String, String> _text;

  /// 出力されるメッセージ.
  @override
  Map<String, String> get text {
    if (_text is EqualUnmodifiableMapView) return _text;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_text);
  }

  /// メッセージ引数.
  final List<String> _placeHolders;

  /// メッセージ引数.
  @override
  List<String> get placeHolders {
    if (_placeHolders is EqualUnmodifiableListView) return _placeHolders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_placeHolders);
  }

  /// メッセージの説明.
  @override
  final String? description;

  @override
  String toString() {
    return 'LocalizedText(dartPackage: $dartPackage, id: $id, text: $text, placeHolders: $placeHolders, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalizedTextImpl &&
            (identical(other.dartPackage, dartPackage) ||
                other.dartPackage == dartPackage) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._text, _text) &&
            const DeepCollectionEquality()
                .equals(other._placeHolders, _placeHolders) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      dartPackage,
      id,
      const DeepCollectionEquality().hash(_text),
      const DeepCollectionEquality().hash(_placeHolders),
      description);

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalizedTextImplCopyWith<_$LocalizedTextImpl> get copyWith =>
      __$$LocalizedTextImplCopyWithImpl<_$LocalizedTextImpl>(this, _$identity);
}

abstract class _LocalizedText extends LocalizedText {
  factory _LocalizedText(
      {required final DartPackage dartPackage,
      required final String id,
      required final Map<String, String> text,
      required final List<String> placeHolders,
      final String? description}) = _$LocalizedTextImpl;
  _LocalizedText._() : super._();

  /// 所属しているPackage.
  @override
  DartPackage get dartPackage;

  /// メッセージを一意に識別するためのID.
  @override
  String get id;

  /// 出力されるメッセージ.
  @override
  Map<String, String> get text;

  /// メッセージ引数.
  @override
  List<String> get placeHolders;

  /// メッセージの説明.
  @override
  String? get description;

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalizedTextImplCopyWith<_$LocalizedTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
