---
name: flutter-use-state-stream
description: >-
  state_stream の利用ガイド。StateStream / MutableStateStream、updateWithLock による
  ロック付き直列更新と割り込み制御、isLocking、close。Stateful なクラス（状態を持つ
  Repository / Delegate / ViewModel 内部状態など）の状態保持に推奨。
  「MutableStateStream で状態を」「ロック付き更新」「送信中の二重実行を防ぐ」
  「Stateful クラスの状態」では必ず使う。Riverpod 橋渡しは
  flutter-use-state-stream-riverpod。README の waitForUpdate 等の旧 API 名に
  引きずられない。
---
# state_stream / 現在値 + Stream

現在値と Stream を持つ軽量状態。更新は `TaskQueue` 経由の `updateWithLock` で直列化する。

## いつ使うか

* **Stateful なクラスを作るとき（推奨）** — 可変状態を持つ Repository / Delegate / 画面内部状態など
* 状態更新を順序保証したい（同一 isolate 内の直列化）
* 進行中の更新に対する割り込み・二重実行を制御したい
* Riverpod 以外でも状態と購読を持ちたい

## 使わないか

* Widget から `ref.watch` したいだけ（→ `flutter-use-state-stream-riverpod` と併用）
* 単なる `StreamController` で足りる一時イベント
* 状態を持たない純関数・stateless なヘルパー

## Stateful クラスでの推奨パターン（Example）

状態を持つクラスでは、フィールドをバラで持たず **`MutableStateStream<状態型>` を正本**にする。
外部からの操作はすべて `updateWithLock` 経由にし、ロック内で「今やってよいか」を判定する。

```dart
final class ExampleTodoStore {
  ExampleTodoStore() : _state = MutableStateStream(const ExampleTodoState());

  final MutableStateStream<ExampleTodoState> _state;

  StateStream<ExampleTodoState> get state => _state;

  /// 保存。既に保存中なら割り込みを拒否する。
  Future<void> save(String title) async {
    final accepted = await _state.updateWithLock<bool>((current, emitter) async {
      if (current.isSaving) {
        return false; // 進行中 → 割り込み拒否
      }
      await emitter.emit(current.copyWith(isSaving: true, title: title));
      return true;
    });
    if (!accepted) {
      return;
    }

    try {
      await _persist(title);
      await _state.updateWithLock((current, emitter) async {
        await emitter.emit(current.copyWith(isSaving: false));
      });
    } catch (_) {
      await _state.updateWithLock((current, emitter) async {
        await emitter.emit(current.copyWith(isSaving: false));
      });
      rethrow;
    }
  }

  Future<void> dispose() => _state.close();
}
```

## ロックと割り込み制御

* `updateWithLock` は内部キューで **同時に 1 本だけ**ブロックを実行する。後から来た更新は待つ（割り込みではなく直列化）
* ブロック内でフラグ（`isSaving` 等）や前提条件を見て **早期 return** すると、「進行中の操作への割り込み拒否」になる
* `isLocking` で「今ロック中か」を外から観察できる（UI の連打抑制など）。`isClosed` なら常に `false`
* ロック外で長い I/O を行い、前後だけ `updateWithLock` で状態遷移する構成もよく使う（ロック保持時間を短くする）

```dart
// ロック中は追加の更新を始めない例（MutableStateStream 参照を持つ側）
if (counter.isLocking) {
  return;
}
await counter.updateWithLock((state, emitter) async {
  await emitter.emit(state + 1);
});
```

進行中拒否は、多くの場合 **ロック内の状態フラグ判定**（上記 `isSaving`）の方が意図が明確である。
`isLocking` は「キュー上でブロック実行中か」の観察用。

## 主な使い方（最小 Example）

```dart
final counter = MutableStateStream<int>(0);

await counter.updateWithLock((state, emitter) async {
  await emitter.emit(state + 1);
  return null;
});

final sub = counter.stream.listen((value) { /* UI 反映など */ });

await sub.cancel();
await counter.close();
```

### 主要 API

* `StateStream<T>`: `state` / `stream`
* `MutableStateStream(initial, {onClose, dispatcher})`
* `updateWithLock(block, {options})` / `close()` / `isClosed` / `isNotClosed` / `isLocking`
* 拡張: `map`, `onClose`, `withFutureContext`, `withSubscription` など

## 組み合わせ

* 内部: `rxdart`, `armyknife_task_queue`, `async_notify2`, `future_context2`
* Riverpod 連携: `state_stream_riverpod`（`ref.watch` 用）
* キャンセル寿命: `withFutureContext` で `FutureContext.close` と連動可

## 解放

**`close()` が必要。** クローズ後の `updateWithLock` / `emit` は `StateStreamClosedException`。
`stream` 購読は別途 `cancel`。`withSubscription` / `withFutureContext` で連動も可。

## 注意

* README の `waitForUpdate` / `waitForWhere` は現行 API に無い
* `Dispatcher` はコールバック生成ではなく実装で渡す
* `StateStream.fromBehaviorSubject` は subject の close を所有しない
* `UpdateWithLockOptions` は現状プレースホルダ（既定のまま使う）
