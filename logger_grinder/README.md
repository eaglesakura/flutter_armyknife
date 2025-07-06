Dartアプリケーション用のシンプルなログライブラリです。統一されたインターフェースで複数のログレベルをサポートし、プラットフォーム固有の最適化も含んでいます。

## Features

- **統一されたログインターフェース**: 4つのログレベル（Debug, Info, Warning, Error）を提供
- **柔軟なLogger生成**: タグ、型、ファイル名、コールバック関数を指定してLoggerを生成
- **ログ出力の抑制**: 条件に応じてログ出力を制御
- **プラットフォーム最適化**: iOS、Android、その他のプラットフォームに応じた最適化された出力
- **カスタマイズ可能**: 独自のログ出力処理を定義可能

## Getting started

pubspec.yamlに依存関係を追加してください：

```yaml
dependencies:
  armyknife_logger: ^1.0.0
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

### 異なるLogger生成方法

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

このライブラリは`logger` package（pub.dev上の人気のログライブラリ）をベースとしており、プラットフォーム固有の最適化が施されています。iOS、Android、その他のプラットフォームに応じて、色付け、絵文字、フォーマットが最適化されます。

バグ報告や機能リクエストは、[GitHub repository](https://github.com/eaglesakura/flutter_armyknife/)でお受けしています。
