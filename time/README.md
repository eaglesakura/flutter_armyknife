軽量な時刻処理ライブラリである。`time_machine`パッケージをベースに、開発者が使いやすい機能を追加している。

## Features

- **軽量な時刻処理**: `time_machine`パッケージのラッパーとして、効率的な時刻処理を提供
- **ClockDelegate**: テストやモッキングに便利な`Clock`のデリゲート実装
- **InstantX**: `Instant`クラスの拡張機能（Unix エポック定数、ミリ秒単位の現在時刻取得）

## Getting started

pubspec.yaml に以下を追加してください：

```yaml
dependencies:
  armyknife_time: ^1.0.0
```

## Usage

基本的な時刻処理：

```dart
import 'package:armyknife_time/armyknife_time.dart';

void main() {
  // 現在時刻を取得
  final now = Instant.now();
  print('現在時刻: $now');

  // ミリ秒単位の現在時刻を取得
  final nowMillis = InstantX.nowMilliSeconds();
  print('現在時刻（ミリ秒）: $nowMillis');

  // Unixエポック時刻を取得
  final epoch = InstantX.epoch;
  print('Unixエポック: $epoch');

  // ClockDelegateを使用したカスタム時刻
  final customClock = ClockDelegate(
    getCurrentInstantDelegate: () => InstantX.epoch,
  );
  final customTime = customClock.getCurrentInstant();
  print('カスタム時刻: $customTime');
}
```

## Additional information

このパッケージは`time_machine`パッケージをベースにしている。より詳細な時刻処理が必要な場合は、`time_machine`パッケージのドキュメントを参照してください。

問題や改善提案がある場合は、[GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues)でお知らせください。
