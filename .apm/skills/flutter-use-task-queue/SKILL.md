---
name: flutter-use-task-queue
description: >-
  armyknife_task_queue（ディレクトリ task_queue）の利用ガイド。TaskQueue による
  非同期タスクの直列実行、queue / join。「順番を保って非同期処理」「TaskQueue」
  では必ず使う。pub 名は armyknife_task_queue。Riverpod コンテナ寿命は
  flutter-use-riverpod-container-async、状態更新直列化は state_stream 側も検討。
---
# armyknife_task_queue / 直列キュー

追加順を保って非同期タスクを直列実行する。ディレクトリ名は `task_queue`、**pub 名は `armyknife_task_queue`**。

## いつ使うか

* 並列ではなく順序保証したい非同期処理
* 他パッケージ内部の直列化基盤として使うとき

## 使わないか

* 単なる `Future.wait` で足りる並列実行
* UI 状態の購読（→ `state_stream` 等）

## 主な使い方（Example）

```dart
import 'package:armyknife_task_queue/armyknife_task_queue.dart';

final q = TaskQueue();
q.queue(() async { /* 1 */ });
final r = await q.queue(() async { /* 2 */ return 42; });
await q.join();
```

### 主要 API

* `TaskQueue()` / `isEmpty` / `isNotEmpty`
* `Future<T> queue(Future<T> Function() block)`
* `Future join()` — 空になるまで待機

## 組み合わせ

* 純 Dart（`synchronized`）。Flutter 非依存
* 上位: `riverpod_container_async`, `state_stream` などが内部利用

## 解放

**不要。** `close` / `dispose` / `cancel` は無い。未完了は `join` で待つ。

## 注意

* README の依存名 `task_queue` は誤り。正は `armyknife_task_queue`
* 例外時も `finally` で次タスクへ進む（キュー全体は止まらない）
