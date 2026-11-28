---
name: flutter-use-async-notify2
description: >-
  async_notify2 の利用ガイド。Notify / NotifyChannel、wait / notify / send /
  receive、dispose と CancellationException。「非同期の wait/notify」
  「チャネルで値を受け渡して」では必ず使う。FutureContext のキャンセル基盤としても
  内部利用される。単なる StreamController だけで足りる場合は使わない。
---
# async_notify2 / wait・notify

Java/Kotlin の `wait` / `notify` を Dart 非同期に再現する。単一合図の `Notify` と型付き送受信の `NotifyChannel`。

## いつ使うか

* 別 Future 間の再開合図が欲しい
* プロデューサー / コンシューマー型の受信待ち

## 使わないか

* 単純な `Completer` 一回きりで足りる場合
* 連続イベント購読だけ（→ Stream）

## 主な使い方（Example）

```dart
final notify = Notify();
final task = notify.wait();
notify.notify();
await task;
await notify.dispose();

final channel = NotifyChannel<int>(notify);
channel.send(42);
final v = await channel.receive();
```

### 主要 API

* `Notify`: `wait` / `notify` / `delay` / `dispose` / `isClosed`
* `NotifyChannel<T>(Notify)`: `send` / `receive` / `isEmpty` / `pendingItemCount`
* `CancellationException` — dispose 後の待機・送受信で投げられる

## 組み合わせ

* 依存: `rxdart`
* 上位: `future_context2` が内部利用（キャンセル例外の出所）

## 解放

**`Notify.dispose()` が必要。** `NotifyChannel` 自体に dispose はなく、共有している `Notify` を利用者が閉じる。

## 注意

* dispose 後の `wait` / `delay` / `send` / `receive` は `CancellationException`
* closed 後の `notify()` は no-op、`send` は例外
