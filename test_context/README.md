Unit Test ごとに 1 つのインスタンスが保証される TestContext オブジェクトを提供するパッケージです。
テストデータの管理と自動クリーンアップ機能により、テストの独立性を保つことができます。

## Features

- **テスト毎のインスタンス保証**: 各 Unit Test で独立した TestContext インスタンスを提供
- **データ管理**: キーバリューストア形式でテストデータを管理
- **自動クリーンアップ**: テスト終了時に自動的にリソースを解放
- **型安全性**: ジェネリクスを使用した型安全なデータアクセス

## Getting started

`pubspec.yaml`に依存関係を追加してください：

```yaml
dev_dependencies:
  armyknife_test_context: ^1.0.0
```

## Usage

TestContext を使用してテストデータを管理する例：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:armyknife_test_context/test_context.dart';

void main() {
  testWidgets('TestContext example', (WidgetTester tester) async {
    final context = TestContext.current();

    // テストデータを設定
    final testData = context.value<String>(
      'test_key',
      (context) => 'test_value',
      onTearDown: (context, value) async {
        print('Cleaning up: $value');
      },
    );

    // データを取得
    final retrievedData = context.valueOf<String>('test_key');
    expect(retrievedData, equals('test_value'));

    // テスト終了時に自動的にクリーンアップされる
  });
}
```

## Additional information

このパッケージは flutter_armyknife プロジェクトの一部として開発されています。
バグレポートや機能要求は [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues) で受け付けています。
