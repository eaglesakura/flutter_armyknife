Flutter+Riverpod 開発において、状態管理を効率的に行うためのサポートライブラリである。
ProviderContainer の構築支援や、Stream の安全な監視、リスト型データの論理一致判定などの
便利なユーティリティ関数群を提供する。

## Features

- **ProviderContainer ビルダー**: 依存関係を効率的に構築するビルダーパターン
- **Stream フック**: UI の安全な Stream 監視機能
- **リスト型プロパティ**: Riverpod での論理一致判定をサポート

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  armyknife_riverpodx: ^1.1.0
  # 必要に応じて個別に追加
  flutter_hooks: ^0.21.2
  flutter_riverpod: ^2.6.1
  hooks_riverpod: ^2.6.1
```

## Usage

Riverpod の便利な機能を提供する：

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

// ProviderContainerの構築
final container = ProviderContainerBuilder()
  .inject(stubProvider, implementationProvider)
  .build();

// Streamの監視
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
* `useFutureContext` 機能は [`future_context2_hooks`](../future_context2_hooks/) パッケージに移行された.
* 非同期処理機能は [`riverpod_container_async`](../riverpod_container_async/) パッケージに移行された.
* 必要に応じて、個別に依存ライブラリのimportを追加する.

### インポートの変更

**1.0.x での書き方:**
```dart
// 1つのインポートですべてのriverpod機能が使える
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureContext = useFutureContext();
    // flutter_hooks、flutter_riverpod、hooks_riverpod すべて利用可能
    return Container();
  }
}
```

**1.1.x での書き方:**
```dart
// 必要なライブラリを個別にインポート
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:future_context2_hooks/future_context2_hooks.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureContext = useFutureContext(); // future_context2_hooksから提供
    // 同じ機能が利用可能
    return Container();
  }
}
```

### 非同期処理機能の移行

**1.0.x での書き方:**
```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
  ],
);

// 非同期初期化・削除処理
await container.waitInitializeTasks();
await container.disposeAsync();
```

**1.1.x での書き方:**
```dart
// 非同期処理機能は別パッケージに移行
import 'package:riverpod_container_async/riverpod_container_async.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
  ],
);

// 同じAPIが利用可能
await container.waitInitializeTasks();
await container.disposeAsync();
```

## Additional information

このパッケージは Flutter 開発における状態管理を効率化するために作られた。

> **注記：** 
> - ProviderContainer の非同期初期化・解放処理については、別パッケージ [`riverpod_container_async`](../riverpod_container_async/) に移行されました。
> - FutureContext と Hooks の統合機能については、別パッケージ [`future_context2_hooks`](../future_context2_hooks/) に移行されました。

バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
