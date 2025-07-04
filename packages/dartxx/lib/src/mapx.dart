class MapX {
  const MapX._();
  static Map<String, dynamic> merge(
    Map<String, dynamic> a,
    Map<String, dynamic> b,
  ) {
    final result = <String, dynamic>{};
    _mergeImpl(result, a, b);
    return result;
  }

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
