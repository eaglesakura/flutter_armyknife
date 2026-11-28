---
name: flutter-use-logger
description: >-
  armyknife_logger（ディレクトリ logger）の利用ガイド。Logger.tag / of / create /
  drop、d/i/w/e、LoggerProxy 差し替え。「armyknife Logger」「Logger.tag」では
  必ず使う。pub 名は armyknife_logger。Flutter 出力は
  flutter-use-logger-flutter、Grinder は flutter-use-logger-grinder。
---
# armyknife_logger / 統一 Logger

4 レベル（d / i / w / e）の統一インターフェース。実出力は `LoggerProxy` の静的差し替えで実装パッケージが担う。
ディレクトリ名は `logger`、**pub 名は `armyknife_logger`**。

## いつ使うか

* アプリ / ツール横断で同じ `Logger` API を使い、出力先だけ差し替えたい

## 使わないか

* Flutter / Grinder 向けの出力実装そのもの（各 `inject` SKILL）

## 主な使い方（Example）

```dart
import 'package:armyknife_logger/armyknife_logger.dart';

final log = Logger.tag('App');
log.i('started');
log.e('failed', err, st);
final quiet = Logger.drop(log, drop: true);
```

### 主要 API

* 生成: `Logger.tag` / `Logger.of` / `Logger.file` / `Logger.create` / `Logger.drop`
* 出力: `d` / `i` / `w` / `e(message, [error, stackTrace])`
* `LoggerProxy` — 未 inject 時は `print('[tag] msg')`

## 組み合わせ

* Flutter: `armyknife_logger_flutter` + `FlutterLogger.inject()`
* Grinder: `armyknife_logger_grinder` + `GrinderLogger.inject()`

## 解放

**不要。**

## 注意

* 単体では print フォールバック。最適化された出力には実装側 `inject()` が必要
* `Logger.file()` は StackTrace 利用の補助想定
