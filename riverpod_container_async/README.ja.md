Riverpod の ProviderContainer の非同期初期化・削除処理をサポートするライブラリである。
Provider 内での非同期初期化タスクの管理や、ProviderContainer 削除時の非同期処理を安全に実行できる。

## Features

- **非同期初期化サポート**: Provider の初期化時に非同期タスクを登録し、完了を待機
- **非同期削除処理**: ProviderContainer 削除時に非同期処理を安全に実行
- **タスクキュー管理**: 初期化・削除タスクを順次実行し、完了を保証

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  riverpod_container_async: ^2.0.0
```

## Usage

```dart
import 'lib/riverpod_container_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 非同期初期化・削除をサポートするProviderContainerの作成
final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
    // 他のoverrides
  ],
);

// Provider内で非同期初期化を行う
final myServiceProvider = Provider((ref) {
  final service = MyService();

  // 非同期初期化タスクを登録
  ref.registerInitializeTasks(service.initialize());

  // 非同期削除処理を登録
  ref.onDisposeAsync(() async {
    await service.dispose();
  });

  return service;
});

// 使用例
void main() async {
  final container = ProviderContainer(
    overrides: ProviderContainerAsyncHelper.inject(),
  );

  // すべての初期化タスクが完了するまで待つ
  await container.waitInitializeTasks();

  // アプリケーションの実行
  runApp(MyApp());

  // 終了時に非同期削除を実行
  await container.disposeAsync();
}
```

## Additional information

このパッケージは Riverpod の ProviderContainer における非同期処理を安全に実行するために作られた。
バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
