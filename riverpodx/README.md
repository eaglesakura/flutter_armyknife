Flutter+Riverpod 開発において、状態管理を効率的に行うための統合ライブラリである。
FlutterHooks、Riverpod、HooksRiverpod を 1 つのパッケージにバンドルし、
さらに開発を便利にするユーティリティ関数群を提供する。

## Features

- **統合された状態管理**: flutter_hooks、flutter_riverpod、hooks_riverpod を一つのインポートで使用可能
- **ProviderContainer ビルダー**: 依存関係を効率的に構築するビルダーパターン
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

// リスト型プロパティを使った論理一致判定
final listProvider = StateProvider<ListSelectProperty<String>>((ref) {
  return ListSelectProperty(['item1', 'item2', 'item3']);
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProperty = ref.watch(listProvider);
    final items = listProperty.requireList();
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

## Migration 1.0.x to 1.1.x

* `riverpod` 系ライブラリのexportが廃止された.
* 必要に応じて、個別に `riverpod` 系のライブラリのimportを追加する.

## Additional information

このパッケージは Flutter 開発における状態管理を効率化するために作られた。

> **注記：** ProviderContainer の非同期初期化・解放処理については、別パッケージ [`riverpod_container_async`](../riverpod_container_async/) に移行されました。非同期処理が必要な場合はそちらをご利用ください。

バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
