// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'localized_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalizedText {
  /// 所属しているPackage.
  DartPackage get dartPackage;

  /// メッセージを一意に識別するためのID.
  String get id;

  /// 出力されるメッセージ.
  ///
  /// key: 言語コード
  /// value: メッセージ
  /// e.g.) {'ja': 'こんにちは', 'en': 'Hello'}
  Map<String, String> get text;

  /// メッセージ引数.
  List<String> get placeHolders;

  /// メッセージの説明.
  String? get description;

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocalizedTextCopyWith<LocalizedText> get copyWith =>
      _$LocalizedTextCopyWithImpl<LocalizedText>(
          this as LocalizedText, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocalizedText &&
            (identical(other.dartPackage, dartPackage) ||
                other.dartPackage == dartPackage) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.text, text) &&
            const DeepCollectionEquality()
                .equals(other.placeHolders, placeHolders) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      dartPackage,
      id,
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(placeHolders),
      description);

  @override
  String toString() {
    return 'LocalizedText(dartPackage: $dartPackage, id: $id, text: $text, placeHolders: $placeHolders, description: $description)';
  }
}

/// @nodoc
abstract mixin class $LocalizedTextCopyWith<$Res> {
  factory $LocalizedTextCopyWith(
          LocalizedText value, $Res Function(LocalizedText) _then) =
      _$LocalizedTextCopyWithImpl;
  @useResult
  $Res call(
      {DartPackage dartPackage,
      String id,
      Map<String, String> text,
      List<String> placeHolders,
      String? description});
}

/// @nodoc
class _$LocalizedTextCopyWithImpl<$Res>
    implements $LocalizedTextCopyWith<$Res> {
  _$LocalizedTextCopyWithImpl(this._self, this._then);

  final LocalizedText _self;
  final $Res Function(LocalizedText) _then;

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
    return _then(_self.copyWith(
      dartPackage: null == dartPackage
          ? _self.dartPackage
          : dartPackage // ignore: cast_nullable_to_non_nullable
              as DartPackage,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      placeHolders: null == placeHolders
          ? _self.placeHolders
          : placeHolders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _LocalizedText extends LocalizedText {
  _LocalizedText(
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
  ///
  /// key: 言語コード
  /// value: メッセージ
  /// e.g.) {'ja': 'こんにちは', 'en': 'Hello'}
  final Map<String, String> _text;

  /// 出力されるメッセージ.
  ///
  /// key: 言語コード
  /// value: メッセージ
  /// e.g.) {'ja': 'こんにちは', 'en': 'Hello'}
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

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LocalizedTextCopyWith<_LocalizedText> get copyWith =>
      __$LocalizedTextCopyWithImpl<_LocalizedText>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalizedText &&
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

  @override
  String toString() {
    return 'LocalizedText(dartPackage: $dartPackage, id: $id, text: $text, placeHolders: $placeHolders, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$LocalizedTextCopyWith<$Res>
    implements $LocalizedTextCopyWith<$Res> {
  factory _$LocalizedTextCopyWith(
          _LocalizedText value, $Res Function(_LocalizedText) _then) =
      __$LocalizedTextCopyWithImpl;
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
class __$LocalizedTextCopyWithImpl<$Res>
    implements _$LocalizedTextCopyWith<$Res> {
  __$LocalizedTextCopyWithImpl(this._self, this._then);

  final _LocalizedText _self;
  final $Res Function(_LocalizedText) _then;

  /// Create a copy of LocalizedText
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dartPackage = null,
    Object? id = null,
    Object? text = null,
    Object? placeHolders = null,
    Object? description = freezed,
  }) {
    return _then(_LocalizedText(
      dartPackage: null == dartPackage
          ? _self.dartPackage
          : dartPackage // ignore: cast_nullable_to_non_nullable
              as DartPackage,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self._text
          : text // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      placeHolders: null == placeHolders
          ? _self._placeHolders
          : placeHolders // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
