---
name: pub-flutter-time
description: >-
  armyknife_time（ディレクトリ time）の利用ガイド。time_machine の Instant / Time /
  Clock re-export、ClockDelegate、InstantX。「Instant.now」「テストで時計を差し替え」
  「armyknife_time」では必ず使う。pub 名は armyknife_time。詳細な暦演算は
  time_machine ドキュメントを正とする。
---
# armyknife_time / 時刻ラッパ

`time_machine` の薄いラッパ。`Instant` / `Time` / `Clock` を re-export し、`ClockDelegate` と `InstantX` を足す。
ディレクトリ名は `time`、**pub 名は `armyknife_time`**。

## いつ使うか

* time_machine ベースの時刻処理
* テストで現在時刻を差し替えたい

## 使わないか

* `DateTime` だけで足りる単純な日付表示
* 詳細な暦 API の正本（→ `time_machine` 本体ドキュメント）

## 主な使い方（Example）

```dart
import 'package:armyknife_time/armyknife_time.dart';

final now = Instant.now();
final ms = InstantX.nowMilliSeconds(); // 戻り値は Instant（ms 精度に正規化）

final clock = ClockDelegate(
  getCurrentInstantDelegate: () => InstantX.epoch,
);
clock.getCurrentInstant();
```

### 主要 API

* re-export: `Instant`, `Time`, `Clock`
* `ClockDelegate({origin, getCurrentInstantDelegate})`
* `InstantX.epoch` / `InstantX.nowMilliSeconds()`

## 組み合わせ

* `time_machine`
* Flutter SDK 依存あり（純 Dart 単体向けではない）

## 解放

**不要。**

## 注意

* `nowMilliSeconds()` の戻り値は `Instant`（名前は精度の意味）
* 依存宣言・import は `armyknife_time`
