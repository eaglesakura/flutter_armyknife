import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_watch_plus/src/watch_value.dart';

void main() {
  test('setを比較', () {
    final a = {1, 2, 3};
    final b = {1, 2, 3};
    final c = {1, 2, 3, 4};
    // 直接比較は常に異なる
    expect(a == b, isFalse);
    expect(a == c, isFalse);

    // 中間オブジェクトを使用して比較
    expect(WatchValue(a) == WatchValue(b), isTrue);
    expect(WatchValue(a) == WatchValue(c), isFalse);
  });

  test('mapを比較', () {
    final a = {1: 'a', 2: 'b', 3: 'c'};
    final b = {1: 'a', 2: 'b', 3: 'c'};
    final c = {1: 'a', 2: 'b', 3: 'c', 4: 'd'};
    // 直接比較は常に異なる
    expect(a == b, isFalse);
    expect(a == c, isFalse);

    // 中間オブジェクトを使用して比較
    expect(WatchValue(a) == WatchValue(b), isTrue);
    expect(WatchValue(a) == WatchValue(c), isFalse);
  });

  test('listを比較', () {
    final a = [1, 2, 3];
    final b = [1, 2, 3];
    final c = [1, 2, 3, 4];
    // 直接比較は常に異なる
    expect(a == b, isFalse);
    expect(a == c, isFalse);

    // 中間オブジェクトを使用して比較
    expect(WatchValue(a) == WatchValue(b), isTrue);
    expect(WatchValue(a) == WatchValue(c), isFalse);
  });

  test('mapとlistを比較', () {
    final a = {1: 'a', 2: 'b', 3: 'c'};
    final b = [1, 2, 3];
    // 直接比較は常に異なる
    // ignore: unrelated_type_equality_checks
    expect(a == b, isFalse);

    // 中間オブジェクトを使用して比較
    expect(WatchValue(a) == WatchValue(b), isFalse);
  });

  test('Objectを比較', () {
    final a = _DummyObject('a');
    final b = _DummyObject('a');
    final c = _DummyObject('b');
    // 直接比較で一致
    expect(a == b, isTrue);

    // 中間オブジェクトを使用して比較
    expect(WatchValue(a) == WatchValue(b), isTrue);
    expect(WatchValue(a) == WatchValue(c), isFalse);
  });

  test('nullを比較', () {
    const a = null;
    const b = null;
    // 直接比較で一致
    expect(a == b, isTrue);

    // 中間オブジェクトを使用して比較
    expect(const WatchValue(a) == const WatchValue(b), isTrue);
  });

  test('nullとObjectを比較', () {
    const a = null;
    final b = _DummyObject('a');
    // 直接比較は常に異なる
    expect(a == b, isFalse);

    // 中間オブジェクトを使用して比較
    expect(const WatchValue(a) == WatchValue(b), isFalse);
  });

  test('プリミティブ型を比較', () {
    const a = 1;
    const b = 1;
    // 直接比較で一致
    expect(a == b, isTrue);

    // 中間オブジェクトを使用して比較
    expect(const WatchValue(a) == const WatchValue(b), isTrue);
  });

  test('プリミティブ型とObjectを比較', () {
    const a = 1;
    final b = _DummyObject('a');
    // 直接比較は常に異なる
    // ignore: unrelated_type_equality_checks
    expect(a == b, isFalse);

    // 中間オブジェクトを使用して比較
    expect(const WatchValue(a) == WatchValue(b), isFalse);
  });
}

class _DummyObject {
  final String value;

  _DummyObject(this.value);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _DummyObject && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
