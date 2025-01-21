extension MapEntryIterableToMap<K, V> on Iterable<MapEntry<K, V>> {
  /// ListからMapへ変換する
  Map<K, V> toMap() {
    final result = <K, V>{};
    result.addEntries(this);
    return result;
  }
}
