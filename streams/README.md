`armyknife_streams`は、RxDart を基盤とした Stream 操作を簡単にするための軽量なユーティリティライブラリです。
複数の Stream の結合、生成型 Stream、Future から Stream への変換など、日常的な Stream 処理の糖衣構文を提供します。

## Features

- **Stream 結合**: 複数の Stream を型安全な tuple として結合する`combineLatest2`、`combineLatest3`、`combineLatest4`
- **生成型 Stream**: `StreamEmitter`を使用して非同期処理から順次値を発行する`generate`
- **Future 変換**: `Future`を Null 通知可能な`Stream`に変換する`fromFutureNullable`
- **軽量**: 必要最小限の API で、直感的な Stream 操作を提供

## Getting started

`pubspec.yaml`に依存関係を追加してください：

```yaml
dependencies:
  armyknife_streams: ^1.0.0
```

## Usage

### 複数の Stream の結合

```dart
import 'package:armyknife_streams/armyknife_streams.dart';

// 2つのStreamを結合
final stream1 = Stream.periodic(Duration(seconds: 1), (i) => i);
final stream2 = Stream.periodic(Duration(seconds: 2), (i) => 'count: $i');

final combined = Streams.combineLatest2(stream1, stream2);
combined.listen((tuple) {
  print('${tuple.$1}, ${tuple.$2}'); // (int, String)型のtuple
});
```

### 生成型 Stream

```dart
// 非同期処理から順次値を発行
final generatedStream = Streams.generate<int>((emitter) async {
  for (int i = 0; i < 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    emitter.value = i;
  }
});

generatedStream.listen((value) => print(value)); // 0, 1, 2, 3, 4
```

### Future から Stream への変換

```dart
final future = Future.delayed(Duration(seconds: 2), () => 'Hello');
final stream = Streams.fromFutureNullable(future);

stream.listen((value) => print(value)); // null, then "Hello"
```

## Additional information

このパッケージは[flutter_armyknife](https://github.com/eaglesakura/flutter_armyknife/)プロジェクトの一部として開発されています。
バグ報告や機能要望は、GitHub の Issue にてお知らせください。

RxDart の高度な機能を使用したい場合は、直接 RxDart ライブラリをご利用ください。
