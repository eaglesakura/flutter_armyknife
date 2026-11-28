---
name: flutter-use-riverpod-container-async
description: >-
  riverpod_container_async の利用ガイド。ProviderContainer の非同期初期化待ちと
  disposeAsync による非同期解放、registerInitializeTasks / onDisposeAsync、
  ProviderContainerAsyncHelper.inject。「コンテナ初期化を待って」「disposeAsync」
  「Provider の非同期破棄」では必ず使う。テスト専用 API は
  flutter-use-riverpod-container-async-test、単なる Riverpod 規約のみでは使わない。
---
# riverpod_container_async / 非同期コンテナ寿命

Riverpod の `ProviderContainer` に、初期化タスクの待機と破棄時の非同期クリーンアップを足す。

## いつ使うか

* 起動時に複数 Provider の非同期初期化完了を待ちたい
* `dispose()` だけでは待てない非同期クリーンアップをコンテナ終了時に保証したい

## 使わないか

* Unit Test 専用の `testReady` / `testGet`（→ `flutter-use-riverpod-container-async-test`）
* 同期だけの Provider 寿命管理

## 主な使い方（Example）

```dart
final container = ProviderContainer(
  overrides: [...ProviderContainerAsyncHelper.inject()],
);

final serviceProvider = Provider((ref) {
  final service = ExampleService();
  ref.registerInitializeTasks(service.initialize());
  ref.onDisposeAsync(() async => service.dispose());
  return service;
});

await container.waitInitializeTasks();
// ...
await container.disposeAsync();
```

### 主要 API

* `ProviderContainerAsyncHelper.inject()` → コンテナ作成時の `overrides` に必須
* `ProviderContainer.waitInitializeTasks()` / `disposeAsync()`
* `Ref.registerInitializeTasks(Future)` / `onDisposeAsync(...)` / `waitInitializeTasks()`

## 組み合わせ

* `flutter_riverpod` / `riverpod`（^3）
* `armyknife_task_queue`（内部の直列キュー）

## 解放

**`disposeAsync()` を使う。** 先に同期 `dispose()`、続けて `onDisposeAsync` 登録分をキュー完了まで待つ。
通常の `dispose()` だけでは非同期クリーンアップを待てない。

## 注意

* `inject()` なしで Helper を読むと `UnimplementedError`
* import は `package:riverpod_container_async/riverpod_container_async.dart`
