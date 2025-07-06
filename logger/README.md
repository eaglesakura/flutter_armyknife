# armyknife_logger

Dart アプリケーション用のログライブラリの統一インターフェースです。具体的な実装は別パッケージで提供され、プラットフォームや用途に応じて選択できます。

## Features

- **統一されたログインターフェース**: 4 つのログレベル（Debug, Info, Warning, Error）の抽象化
- **柔軟な Logger 生成**: タグ、型、ファイル名、コールバック関数を指定して Logger を生成
- **ログ出力の抑制**: 条件に応じてログ出力を制御
- **プラットフォーム非依存**: 具体的な実装は別パッケージで提供
- **カスタマイズ可能**: 独自のログ出力処理を定義可能

## 実装パッケージ

このパッケージは抽象化されたインターフェースを提供します。実際の使用には以下の実装パッケージが必要です：

- **armyknife_logger_flutter**: Flutter/Dart アプリケーション用の実装
- **armyknife_logger_grinder**: Grinder ビルドツール用の実装

## Getting started

通常、このパッケージを直接使用することはありません。代わりに、用途に応じて実装パッケージを選択してください：

### Flutter アプリケーションの場合

```yaml
dependencies:
  armyknife_logger_flutter: ^1.0.0
```

### Grinder ビルドツールの場合

```yaml
dependencies:
  armyknife_logger_grinder: ^1.0.0
```

## Usage

### 基本的な使用方法

```dart
import 'package:armyknife_logger/armyknife_logger.dart';

// タグを指定してLoggerを生成
final logger = Logger.tag('MyApp');

// 各レベルのログ出力
logger.i('アプリケーションが開始されました');
logger.d('デバッグ情報');
logger.w('警告メッセージ');
logger.e('エラーが発生しました', error, stackTrace);
```

### 異なる Logger 生成方法

```dart
// 型を指定してLoggerを生成
final logger = Logger.of(MyClass);

// 現在のファイル名をタグとしてLoggerを生成
final logger = Logger.file();

// カスタムコールバック関数を指定してLoggerを生成
final logger = Logger.create(
  info: (message) => print('INFO: $message'),
  debug: (message) => print('DEBUG: $message'),
  warning: (message) => print('WARNING: $message'),
  error: (message, [error, stackTrace]) => print('ERROR: $message'),
);

// 条件に応じてログ出力を抑制
final logger = Logger.drop(originalLogger, drop: !kDebugMode);
```

## Additional information

このパッケージは、複数のプラットフォームやツールチェーンで統一されたログインターフェースを提供することを目的としています。具体的な実装は目的に応じて実装パッケージを選択してください。

バグ報告や機能リクエストは、[GitHub repository](https://github.com/eaglesakura/flutter_armyknife/)でお受けしています。
