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

  static void _mergeImpl(
    Map<dynamic, dynamic> result,
    Map<dynamic, dynamic> a,
    Map<dynamic, dynamic> b,
  ) {
    final keys = {
      ...a.keys,
      ...b.keys,
    };
    for (final key in keys) {
      if (b.containsKey(key)) {
        if (a[key] is Map && b[key] is Map) {
          final child = <dynamic, dynamic>{};
          _mergeImpl(
            child,
            a[key] as Map<dynamic, dynamic>,
            b[key] as Map<dynamic, dynamic>,
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
