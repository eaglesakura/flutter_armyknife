class MapX {
  const MapX._();
  static Map<K, V> merge<K, V>(
    Map<K, V> a,
    Map<K, V> b,
  ) {
    final result = <K, V>{};
    _mergeImpl(result, a, b);
    return result;
  }

  static void _mergeImpl<K, V>(
    Map<K, V> result,
    Map<K, V> a,
    Map<K, V> b,
  ) {
    final keys = {
      ...a.keys,
      ...b.keys,
    };
    for (final key in keys) {
      if (b.containsKey(key)) {
        if (a[key] is Map && b[key] is Map) {
          final child = <K, V>{};
          _mergeImpl(
            child,
            a[key] as Map<K, V>,
            b[key] as Map<K, V>,
          );
          result[key] = child as V;
        } else {
          result[key] = b[key] as V;
        }
      } else {
        result[key] = a[key] as V;
      }
    }
  }
}
