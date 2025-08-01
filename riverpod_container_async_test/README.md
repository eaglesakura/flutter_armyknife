<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

`armyknife_riverpodx`を使用したコードの Unit Test 作成を支援するテストライブラリである。
ProviderContainer の非同期削除機能、依存関係の自動解決、テスト用のプロバイダー管理機能を提供する。

## Features

- **自動的な ProviderContainer 管理**: テスト用の ProviderContainer を自動作成・削除
- **非同期削除サポート**: テスト終了時に ProviderContainer を適切に非同期削除
- **依存関係の自動解決**: プロバイダーの依存グラフを構築し、準備完了状態にする
- **AutoDisposeProvider 対応**: 自動的に listen を行い、適切にプロバイダーを管理
- **テスト用ヘルパー**: 簡単にプロバイダーからインスタンスを取得できる拡張機能

## Getting started

`pubspec.yaml`の dev_dependencies に以下を追加する：

```yaml
dev_dependencies:
  armyknife_riverpodx_test: ^1.0.0
```

## Usage

テスト用の ProviderContainer を作成し、プロバイダーをテストする：

```dart
import 'package:armyknife_riverpodx_test/armyknife_riverpodx_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider tests', () {
    test('should create provider container with async disposal', () async {
      final container = ProviderContainerTest.create();

      // プロバイダーの値を取得
      final value = container.testGet(myProvider);
      expect(value, isNotNull);

      // テスト終了時に自動的にdisposeAsync()が呼ばれる
    });

    test('should ready provider with dependencies', () async {
      final container = ProviderContainerTest.create();

      // 依存関係を解決してプロバイダーを準備完了状態にする
      final service = await container.testReady(myServiceProvider);
      expect(service.isReady, isTrue);
    });
  });
}
```

## Additional information

このパッケージは`armyknife_riverpodx`を使用したアプリケーションの
Unit Test 作成を簡単にするために作られた。
特に ProviderContainer の非同期削除機能により、テスト間でのリソースリークを防ぐことができる。
バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
