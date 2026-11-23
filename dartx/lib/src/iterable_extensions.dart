/// [MapEntry] の列からMapを組み立てる拡張.
extension MapEntryIterableToMap<K, V> on Iterable<MapEntry<K, V>> {
  /// ListからMapへ変換する.
  ///
  /// 同一キーが複数ある場合は後勝ちとなる.
  ///
  /// Example:
  /// ```dart
  /// final map = [MapEntry('a', 1)].toMap();
  /// ```
  Map<K, V> toMap() {
    final result = <K, V>{};
    result.addEntries(this);
    return result;
  }
}

/// 重複排除した列挙を提供する拡張.
extension IterableDistinctUnique<E> on Iterable<E> {
  /// 重複を排除した要素を返す.
  ///
  /// 出現順を保ち、最初に現れた要素のみを残す.
  ///
  /// Example:
  /// ```dart
  /// final unique = [1, 1, 2].distinctUnique().toList();
  /// ```
  Iterable<E> distinctUnique() sync* {
    final tmp = <E>{};
    for (final e in this) {
      if (tmp.contains(e)) {
        continue;
      }
      tmp.add(e);
      yield e;
    }
  }
}
