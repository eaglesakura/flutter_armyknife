---
name: pub-flutter-state-stream-riverpod
description: >-
  state_stream_riverpod の利用ガイド。StateStreamProvider.autoDispose.state /
  stateBy で StateStream を ref.watch 可能にする。「StateStream を Provider 化」
  「StateStreamProvider」では必ず使う。StateStream 本体の更新・close は
  pub-flutter-state-stream。README の StateStreamProviders 表記は誤り。
---
# state_stream_riverpod / Riverpod 橋渡し

`StateStream` の現在値を `NotifierProvider.autoDispose` 経由で `ref.watch` できるようにする。

## いつ使うか

* 既存の `MutableStateStream` / `StateStream` を Widget から watch したい

## 使わないか

* StateStream 自体の作成・`updateWithLock`・`close`（→ `pub-flutter-state-stream`）

## 主な使い方（Example）

```dart
final streamProvider = Provider.autoDispose<MutableStateStream<int>>((ref) {
  final s = MutableStateStream(0);
  ref.onDispose(() {
    s.close();
  });
  return s;
});

final valueProvider = StateStreamProvider.autoDispose.state(streamProvider);

// Widget: ref.watch(valueProvider)
```

### 主要 API

* `StateStreamProvider.autoDispose.state(Provider<StateStream<T>>)`
* `StateStreamProvider.autoDispose.stateBy(valueProvider, selector)`

（クラス名は **`StateStreamProvider`**。複数形ではない。）

## 組み合わせ

* `state_stream`
* `flutter_riverpod`（^3）

## 解放

* Provider 側の StreamSubscription は `ref.onDispose` で自動 cancel
* **`MutableStateStream.close()` は利用者が `ref.onDispose` 等で行う**

## 注意

* 更新は元の `StateStream` を `read` して行う（このパッケージは橋のみ）
* README の戻り型 `AutoDisposeProvider` 表記は実装上 `NotifierProvider`
