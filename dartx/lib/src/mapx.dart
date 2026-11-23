/// ネストしたMapのマージを提供するユーティリティ.
class MapX {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // MapX は静的メソッドのみ利用する
  /// ```
  const MapX._();

  /// [a]と[b]を再帰的にマージした新しいMapを返す.
  ///
  /// 同一キーで双方がMapの場合は子要素を再帰マージし、それ以外は[b]の値を優先する.
  ///
  /// Example:
  /// ```dart
  /// final merged = MapX.merge(
  ///   {'a': 1, 'nested': {'x': 1}},
  ///   {'b': 2, 'nested': {'y': 2}},
  /// );
  /// ```
  static Map<String, dynamic> merge(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final result = <String, dynamic>{};
    _mergeImpl(result, a, b);
    return result;
  }

  /// [result]へ[a]と[b]のマージ結果を書き込む.
  ///
  /// 双方に存在するキーで値がMap同士なら再帰し、そうでなければ[b]を採用する.
  ///
  /// Example:
  /// ```dart
  /// final merged = MapX.merge({'a': 1}, {'b': 2});
  /// ```
  static void _mergeImpl(
    Map<String, dynamic> result,
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final keys = {
      ...a.keys,
      ...b.keys,
    };
    for (final key in keys) {
      if (b.containsKey(key)) {
        if (a[key] is Map && b[key] is Map) {
          final child = <String, dynamic>{};
          _mergeImpl(
            child,
            a[key] as Map<String, dynamic>,
            b[key] as Map<String, dynamic>,
          );
          result[key] = child;
        } else {
          result[key] = b[key];
        }
      } else {
        result[key] = a[key];
      }
    }
  }
}
