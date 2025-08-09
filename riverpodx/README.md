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
  # ListSelectPropertyの代替として推奨
  flutter_riverpod_watch_plus: ^1.0.0
```

## Usage

Riverpod の便利な機能を提供する：

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';
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

// リスト型プロパティ（v1.1.1で非推奨になりました）
// 代わりに flutter_riverpod_watch_plus を使用することを推奨
final listProvider = StateProvider<List<String>>((ref) {
  return ['item1', 'item2', 'item3'];
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watchBy()を使用して効率的な監視を行う
    final items = ref.watchBy(listProvider, (list) => list);
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

## Migration 1.0.0 to 1.1.0

version 1.1.0では、ライブラリの構造を整理し、機能を専門化されたパッケージに分離しました。

### 主な変更点

* `riverpod` 系ライブラリのexportが廃止された
* `useFutureContext` 機能は [`future_context2_hooks`](../future_context2_hooks/) パッケージに移行
* 非同期処理機能は [`riverpod_container_async`](../riverpod_container_async/) パッケージに移行
* 必要に応じて、個別に依存ライブラリのimportを追加する必要がある

### インポートの変更

**1.0.0 での書き方:**
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

**1.1.0 での書き方:**
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

**1.0.0 での書き方:**
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

**1.1.0 での書き方:**
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

## Migration 1.1.0 to 1.1.1

version 1.1.1では、`ListSelectProperty` が非推奨になり、より効率的で使いやすい [`flutter_riverpod_watch_plus`](../flutter_riverpod_watch_plus/) パッケージに移行されました。

### ListSelectProperty の移行

**1.1.0 での書き方（非推奨）:**
```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

// ListSelectPropertyを使用したリスト状態管理
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

**1.1.1 での書き方（推奨）:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';

// 直接Listを扱い、watchBy()で効率的に監視
final listProvider = StateProvider<List<String>>((ref) {
  return ['item1', 'item2', 'item3'];
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watchBy()により、内容が同じ場合は再描画されない
    final items = ref.watchBy(listProvider, (list) => list);
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

### 必要な依存関係

`pubspec.yaml`に以下を追加：
```yaml
dependencies:
  flutter_riverpod_watch_plus: ^1.0.0
```

### 移行のメリット

1. **よりシンプルなAPI**: ラッパークラスが不要で、直接リストを扱える
2. **効率的な状態監視**: `watchBy()` により不要な再描画を防ぐ
3. **型安全性**: `requireList()` のような例外を投げるメソッドが不要
4. **柔軟性**: List以外のコレクション（Map、Set）にも対応

## Additional information

このパッケージは Flutter 開発における状態管理を効率化するために作られた。

> **注記：** 
> - ProviderContainer の非同期初期化・解放処理については、別パッケージ [`riverpod_container_async`](../riverpod_container_async/) に移行されました。
> - FutureContext と Hooks の統合機能については、別パッケージ [`future_context2_hooks`](../future_context2_hooks/) に移行されました。

バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
