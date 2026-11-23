/// Mapを生成する.
///
/// [builder] に渡した可変Mapへ要素を追加し、完成したMapを返す.
///
/// Example:
/// ```dart
/// final map = buildMap<String, int>((m) {
///   m['a'] = 1;
/// });
/// ```
Map<K, V> buildMap<K, V>(
  void Function(Map<K, V> map) builder,
) {
  final map = <K, V>{};
  builder(map);
  return map;
}

/// Listを生成する.
///
/// [builder] に渡した可変Listへ要素を追加し、完成したListを返す.
///
/// Example:
/// ```dart
/// final list = buildList<int>((l) {
///   l.add(1);
/// });
/// ```
List<E> buildList<E>(
  void Function(List<E> list) builder,
) {
  final list = <E>[];
  builder(list);
  return list;
}

/// Setを生成する.
///
/// [builder] に渡した可変Setへ要素を追加し、完成したSetを返す.
///
/// Example:
/// ```dart
/// final set = buildSet<String>((s) {
///   s.add('a');
/// });
/// ```
Set<E> buildSet<E>(
  void Function(Set<E> set) builder,
) {
  final set = <E>{};
  builder(set);
  return set;
}
