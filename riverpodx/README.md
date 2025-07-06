Flutter+Riverpod 開発において、状態管理を効率的に行うための統合ライブラリである。
FlutterHooks、Riverpod、HooksRiverpod を 1 つのパッケージにバンドルし、
さらに開発を便利にするユーティリティ関数群を提供する。

## Features

- **統合された状態管理**: flutter_hooks、flutter_riverpod、hooks_riverpod を一つのインポートで使用可能
- **ProviderContainer ビルダー**: 依存関係を効率的に構築するビルダーパターン
- **非同期処理サポート**: ProviderContainer の非同期初期化・解放処理
- **Stream フック**: UI の安全な Stream 監視機能
- **FutureContext ライフサイクル**: Widget と FutureContext の自動連携
- **リスト型プロパティ**: Riverpod での論理一致判定をサポート

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  armyknife_riverpodx: ^1.0.0
```

## Usage

単一の import で Riverpod と Hooks の全機能を使用できる：

```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

// ProviderContainerの構築
final container = ProviderContainerBuilder()
  .inject(stubProvider, implementationProvider)
  .build();

// Streamの監視
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureContext = useFutureContext();

    useEventStream(
      () => someStream,
      (data) {
        // データを安全に処理
      },
    );

    return Container();
  }
}
```

```dart
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

このパッケージは Flutter 開発における状態管理を効率化するために作られた。
バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
