---
name: pub-flutter-logger-grinder
description: >-
  armyknife_logger_grinder（ディレクトリ logger_grinder）の利用ガイド。
  GrinderLogger.inject、context.log への出力。「Grinder で Logger」「grind タスク
  のログ」では必ず使う。Logger API 本体は pub-flutter-logger。Flutter アプリ
  向けではない。
---
# armyknife_logger_grinder / Grinder 出力

Grinder ビルド向け Logger 実装。`context.log` に流す。
ディレクトリ名は `logger_grinder`、**pub 名は `armyknife_logger_grinder`**。

## いつ使うか

* Grinder タスク（tool/grind）で統一 Logger API を使うとき

## 使わないか

* Flutter アプリ（→ `pub-flutter-logger-flutter`）

## 主な使い方（Example）

```dart
import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:armyknife_logger_grinder/armyknife_logger_grinder.dart';
import 'package:grinder/grinder.dart';

void main(List<String> args) {
  GrinderLogger.inject();
  // @Task 内で Logger.tag('Build').i(...);
}
```

### 主要 API

* `GrinderLogger.inject()` のみ（`Logger` は **re-export しない**）

## 組み合わせ

* `armyknife_logger`
* `grinder`

## 解放

**不要。**

## 注意

* `inject()` 必須。未 inject だと print フォールバック
* `context.log` 前提のため、Grinder タスク外では意味が薄い
