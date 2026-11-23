import 'package:flutter_test/flutter_test.dart';

/// Unit Testごとに1つのインスタンスが保証されるContextオブジェクト.
///
/// 値の管理やExtensionのownerとして利用する.
/// [TestContext.current] で取得し、tearDownで自動破棄される.
class TestContext {
  /// 現在のテストに紐づくシングルトン.
  static TestContext? _instance;

  /// 登録されたデータ.
  ///
  /// キーに紐づくテスト用オブジェクトを保持する.
  final Map<dynamic, dynamic> _testData = {};

  /// 現在のテストに紐づくコンテキストを返す.
  ///
  /// 初回呼び出しで生成し、`addTearDown` で `_instance` をクリアする.
  /// 同一テスト内では同じインスタンスが再利用される.
  ///
  /// Example:
  /// ```dart
  /// test('example', () {
  ///   final context = TestContext.current();
  ///   context.value('key', (_) => 1);
  /// });
  /// ```
  factory TestContext.current() {
    if (_instance == null) {
      _instance = TestContext._();
      addTearDown(() async {
        _instance = null;
      });
    }
    return _instance!;
  }

  /// 空のコンテキストを生成する.
  ///
  /// Example:
  /// ```dart
  /// // 通常は [TestContext.current] 経由で取得する.
  /// final context = TestContext.current();
  /// ```
  TestContext._();

  /// 指定のキーに対応するデータを取得する.
  ///
  /// [key] が未登録の場合は [StateError] を発生する.
  ///
  /// Example:
  /// ```dart
  /// final context = TestContext.current();
  /// context.value('n', (_) => 42);
  /// final n = context.valueOf<int>('n');
  /// ```
  T valueOf<T>(dynamic key) {
    if (!_testData.containsKey(key)) {
      throw StateError('Not found key: $key');
    }
    return _testData[key] as T;
  }

  /// テスト中に有効なデータを取得する.
  ///
  /// [key] が未登録なら [factory] で生成して登録する.
  /// [onTearDown] を渡すと、テスト終了時にクリーンアップを実行する.
  /// 同一キーでは初回生成値が再利用される.
  ///
  /// Example:
  /// ```dart
  /// final db = TestContext.current().value(
  ///   'db',
  ///   (_) => Database.connect(),
  ///   onTearDown: (_, db) => db.close(),
  /// );
  /// ```
  T value<T>(
    dynamic key,
    T Function(TestContext context) factory, {
    Future Function(TestContext context, T value)? onTearDown,
  }) {
    if (!_testData.containsKey(key)) {
      final value = factory(this);
      _testData[key] = value;
      addTearDown(() async {
        if (onTearDown != null) {
          await onTearDown(this, value);
        }
      });
    }
    return _testData[key] as T;
  }
}
