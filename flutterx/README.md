# armyknife_flutterx

Flutter SDK を便利に使用するための小さな Utility 集です。
テスト環境の判定やフレーム同期などの基本的な機能を提供します。

## Features

- **テスト環境判定**: Flutter の UnitTest 実行中かどうかを判定
- **フレーム同期**: 次の描画フレームタイミングまでの待機処理

## Getting started

pubspec.yaml にパッケージを追加してください：

```yaml
dependencies:
  armyknife_flutterx: ^1.0.0
```

そして、必要なファイルで import してください：

```dart
import 'package:armyknife_flutterx/armyknife_flutterx.dart';
```

## Usage

### テスト環境の判定

```dart
if (isFlutterTesting) {
  // テスト実行中の処理
  print('Flutter test is running');
} else {
  // 通常の実行時の処理
  print('Running in normal mode');
}
```

### フレーム同期待機

```dart
// 次の描画フレームまで待機
await vsync();

// UIの更新後に処理を実行したい場合に有効
widget.updateUI();
await vsync();
// この時点でUIの更新が完了している
```

## Additional information

このパッケージは、Flutter 開発における基本的なユーティリティ機能を提供します。
バグ報告や機能要求は、プロジェクトの Issue トラッカーまでお寄せください。

シンプルで軽量なユーティリティ集として設計されており、
Flutter 開発の効率化に貢献することを目的としています。
