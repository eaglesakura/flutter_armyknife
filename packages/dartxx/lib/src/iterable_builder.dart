/// Mapを生成する.
Map<K, V> buildMap<K, V>(
  void Function(Map<K, V> map) builder,
) {
  final map = <K, V>{};
  builder(map);
  return map;
}

/// Listを生成する.
List<E> buildList<E>(
  void Function(List<E> list) builder,
) {
  final list = <E>[];
  builder(list);
  return list;
}

/// Setを生成する.
Set<E> buildSet<E>(
  void Function(Set<E> set) builder,
) {
  final set = <E>{};
  builder(set);
  return set;
}
