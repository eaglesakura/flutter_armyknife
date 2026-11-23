---
name: pub-flutter-riverpod-container-async-test
description: >-
  riverpod_container_async_test の利用ガイド。ProviderContainer の testGet /
  testReady、非同期初期化付き Provider の Unit Test。「testReady で準備して」
  「autoDispose がテストで消える」では必ず使う。本番の inject / disposeAsync
  本体は pub-flutter-riverpod-container-async を使う。
---
# riverpod_container_async_test / テスト補助

`riverpod_container_async` 利用コードの Unit Test 向けに、`testGet` / `testReady` を提供する（dev_dependencies）。

## いつ使うか

* 非同期初期化付き Provider を、完全準備してから検証したい
* `autoDispose` が `read` 直後に破棄されて困るテスト

## 使わないか

* 本番アプリの初期化・破棄フロー（→ `pub-flutter-riverpod-container-async`）

## 主な使い方（Example）

```dart
final container = ProviderContainer(
  overrides: [...ProviderContainerAsyncHelper.inject()],
);

final service = await container.testReady(serviceProvider);
// 検証...
await container.disposeAsync();
```

### 主要 API

* `testGet(provider)` — `listen` してから `read`（即破棄防止）
* `testReady(provider)` — 依存を再帰準備 → `waitInitializeTasks` → `testGet`

## 組み合わせ

* `riverpod_container_async`
* `flutter_riverpod` / `riverpod`
* `flutter_test`

## 解放

本パッケージは自動解放しない。**テスト側で `disposeAsync()` を明示する。**
（README の「終了時に自動 disposeAsync」は現行実装に無い。）

## 注意

* 依存再帰は主に `NotifierProvider` / `Provider`。`dependencies` 未宣言は辿れない
* import: `package:riverpod_container_async_test/riverpod_container_async_test.dart`
