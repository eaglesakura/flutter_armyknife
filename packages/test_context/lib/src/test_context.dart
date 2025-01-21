import 'package:flutter_test/flutter_test.dart';

/// Unit Testごとに1つのインスタンスが保証されるContextオブジェクト.
/// 値の管理やExtensionのownerとして利用する.
class TestContext {
  static TestContext? _instance;

  /// 登録されたデータ.
  final Map<dynamic, dynamic> _testData = {};

  factory TestContext.current() {
    if (_instance == null) {
      _instance = TestContext._();
      addTearDown(() async {
        _instance = null;
      });
    }
    return _instance!;
  }

  TestContext._();

  /// テスト中に有効なデータを取得する.
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
