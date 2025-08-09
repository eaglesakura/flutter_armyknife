import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

/// [WatchValue] is a wrapper class for the value returned by [Ref.watch].
/// It is used to compare the value with the previous value.
/// [WatchValue] is immutable.
/// [WatchValue] is used to compare the value with the previous value.
@internal
class WatchValue {
  final dynamic value;
  static const _setEquals = SetEquality();
  static const _mapEquals = MapEquality();
  static const _listEquals = ListEquality();
  static const _equals = DeepCollectionEquality();

  const WatchValue(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! WatchValue) {
      return false;
    }

    final a = value;
    final b = other.value;
    if (a is Set && b is Set) {
      return _setEquals.equals(a, b);
    } else if (a is Map && b is Map) {
      return _mapEquals.equals(a, b);
    } else if (a is List && b is List) {
      return _listEquals.equals(a, b);
    } else {
      return _equals.equals(a, b);
    }
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'WatchValue($value)';
}
