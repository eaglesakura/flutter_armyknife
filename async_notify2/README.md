async_notify2

## Features

Kotlin や Java の `notify()` / `wait()` メソッドを Dart で再現するライブラリである。

- **Notify**
  - 非同期処理の待ち合わせ機能を提供する
  - 単一の通知イベントを待機し、通知があると処理を再開する
- **NotifyChannel**
  - 型安全な値の送受信チャンネルを提供する
  - 非同期で値を送信し、受信側で待機することができる

## Usage

### 基本的な Notify の使用例

```dart
// Notify インスタンスを作成
final notify = Notify();

// 別のFutureで通知を待機
final waitTask = notify.wait(); // notify() が呼び出されるまで待機

// 通知を送信
notify.notify();

// 待機していたタスクが完了
await waitTask;

// リソースを解放
notify.dispose();
```

### NotifyChannel を使用した値の送受信

```dart
// 型安全なチャンネルを作成
final notify = Notify();
final channel = NotifyChannel<int>(notify);

// 別のスレッドで値を受信待機
final receiveTask = channel.receive(); // send() が呼び出されるまで待機

// 値を送信
channel.send(42);

// 受信した値を取得
final value = await receiveTask; // value = 42

// リソースを解放
notify.dispose();
```

### 複数の通知を処理する場合

```dart
final notify = Notify();

// 複数回の通知を待機
for (int i = 0; i < 3; i++) {
  await notify.wait(); // 各通知を順次待機
  print('通知 ${i + 1} を受信');
}

notify.dispose();
```

## Additional information

このライブラリは Java/Kotlin の同期プリミティブである `Object.wait()` と `Object.notify()` の概念を Dart の非同期処理に適用したものである。マルチスレッド環境でのタスク同期や、プロデューサー・コンシューマーパターンの実装に適している。

## 参考リンク

- [async_notify](https://github.com/vivitainc/flutter_async_notify)
