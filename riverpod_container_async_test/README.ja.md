`riverpod_container_async`を使用したコードの Unit Test 作成を支援するテストライブラリである。
ProviderContainer の非同期削除機能、依存関係の自動解決、テスト用のプロバイダー管理機能を提供する。

## Features

- **テスト用拡張機能**: `ProviderContainer` に対するテスト専用の拡張メソッドを提供
- **初期化タスク待機**: `riverpod_container_async` の初期化タスクを自動的に待機し、テスト実行前にプロバイダーを完全に準備
- **依存関係の自動解決**: `testReady` でプロバイダーの依存グラフを再帰的に構築し、すべての依存プロバイダーを準備完了状態にする
- **簡単なインスタンス取得**: `testGet` で型安全にプロバイダーからインスタンスを取得

## Getting started

`pubspec.yaml`の dev_dependencies に以下を追加する：

```yaml
dev_dependencies:
  riverpod_container_async_test: ^1.0.0
```

## Usage

テスト用の ProviderContainer を作成し、プロバイダーをテストする：

```dart
import 'package:riverpod_container_async_test/riverpod_container_async_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider tests', () {
    test('should create provider container with async disposal', () async {
      final container = // ProviderContainer作成

      // プロバイダーの値を取得
      final value = container.testGet(myProvider);
      expect(value, isNotNull);

      // テスト終了時に自動的にdisposeAsync()が呼ばれる
    });

    test('should ready provider with dependencies', () async {
      final container = // ProviderContainer作成

      // 依存関係を解決してプロバイダーを準備完了状態にする
      final service = await container.testReady(myServiceProvider);
      expect(service.isReady, isTrue);
    });
  });
}
```

## Additional information

このパッケージは`riverpod_container_async`を使用したアプリケーションの
Unit Test 作成を簡単にするために作られた。
特に ProviderContainer の非同期削除機能により、テスト間でのリソースリークを防ぐことができる。
バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
