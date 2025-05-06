import 'package:collection/collection.dart';

/// List型のRiverpodプロパティ.
/// RiverpodとListを組み合わせた場合、論理一致を判定することができないため、
/// 一致を判定するためのプロパティを作成する.
class ListSelectProperty<T> {
  static const _listEquals = ListEquality();

  final List<T>? list;

  @override
  late final int hashCode = _listEquals.hash(list);

  ListSelectProperty(this.list);

  @override
  bool operator ==(Object other) {
    if (other is! ListSelectProperty<T>) {
      return false;
    }
    return _listEquals.equals(list, other.list);
  }

  @override
  String toString() {
    return list.toString();
  }
}
