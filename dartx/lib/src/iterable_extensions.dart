extension MapEntryIterableToMap<K, V> on Iterable<MapEntry<K, V>> {
  /// ListからMapへ変換する
  Map<K, V> toMap() {
    final result = <K, V>{};
    result.addEntries(this);
    return result;
  }
}

extension IterableDistinctUnique<E> on Iterable<E> {
  /// 重複を排除した要素を返す.
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
