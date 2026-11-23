import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

/// [Ref.watch] が返す値を包む比較用ラッパー.
///
/// 前回値との深い等価比較に使う不変オブジェクト.
/// Collectionは要素内容で比較し、参照が変わっても内容が同じなら等しいとみなす.
@internal
class WatchValue {
  /// 包んでいる元の値.
  final dynamic value;

  /// [Set] 比較用の等価器.
  static const _setEquals = SetEquality();

  /// [Map] 比較用の等価器.
  static const _mapEquals = MapEquality();

  /// [List] 比較用の等価器.
  static const _listEquals = ListEquality();

  /// Collection全般の深い等価比較に使う等価器.
  static const _equals = DeepCollectionEquality();

  /// [value] を包んだ比較用インスタンスを生成する.
  ///
  /// Example:
  /// ```dart
  /// const wrapped = WatchValue([1, 2, 3]);
  /// ```
  const WatchValue(this.value);

  /// 内容に基づく等価比較を行う.
  ///
  /// [Set] / [Map] / [List] は専用の等価器、それ以外は [DeepCollectionEquality] で比較する.
  ///
  /// Example:
  /// ```dart
  /// expect(const WatchValue([1]), const WatchValue([1]));
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! WatchValue) {
      return false;
    }

    final a = value;
    final b = other.value;
    if (a is Set && b is Set) {
      return _setEquals.equals(a, b);
    } else if (a is Map && b is Map) {
      return _mapEquals.equals(a, b);
    } else if (a is List && b is List) {
      return _listEquals.equals(a, b);
    } else {
      return _equals.equals(a, b);
    }
  }

  /// [value] のハッシュコード.
  ///
  /// 深い等価と完全には一致しない場合がある点に注意する.
  @override
  int get hashCode => value.hashCode;

  /// デバッグ向けの文字列表現を返す.
  ///
  /// Example:
  /// ```dart
  /// print(const WatchValue(1)); // WatchValue(1)
  /// ```
  @override
  String toString() => 'WatchValue($value)';
}
