---
name: flutter-use-logger-flutter
description: >-
  armyknife_logger_flutter（ディレクトリ logger_flutter）の利用ガイド。
  FlutterLogger.inject、PrettyPrinter 出力。「Flutter で armyknife Logger」
  「FlutterLogger.inject」では必ず使う。Logger API 本体は flutter-use-logger。
  Logger は本パッケージから re-export されない。
---
# armyknife_logger_flutter / Flutter 出力

`armyknife_logger` の Flutter 向け実装。`logger` パッケージの PrettyPrinter で出す。
ディレクトリ名は `logger_flutter`、**pub 名は `armyknife_logger_flutter`**。

## いつ使うか

* Flutter アプリで armyknife Logger を使うとき

## 使わないか

* Grinder タスク（→ `flutter-use-logger-grinder`）
* Logger API の定義そのもの（→ `flutter-use-logger`）

## 主な使い方（Example）

```dart
import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:armyknife_logger_flutter/armyknife_logger_flutter.dart';

void main() {
  FlutterLogger.inject();
  final log = Logger.tag('App');
  log.i('hello');
}
```

### 主要 API

* `FlutterLogger.inject()` のみ（`Logger` は **re-export しない**）

## 組み合わせ

* `armyknife_logger`
* `logger`（^2）

## 解放

**不要。**

## 注意

* README が `Logger` だけ import している例は不正確。両 import + `inject()` が必要
* 未 inject だとコアの print 実装のまま
