# armyknife_logger_flutter

Flutter アプリケーション用のログライブラリ実装です。`armyknife_logger`の統一インターフェースを使用しながら、Flutter 固有の最適化を提供します。

## Features

- **Flutter 最適化**: Flutter/Dart アプリケーション向けに最適化されたログ出力
- **統一されたログインターフェース**: 4 つのログレベル（Debug, Info, Warning, Error）をサポート
- **プラットフォーム固有の最適化**: iOS、Android、その他のプラットフォームに応じた最適化された出力
- **柔軟な Logger 生成**: タグ、型、ファイル名、コールバック関数を指定して Logger を生成
- **ログ出力の抑制**: 条件に応じてログ出力を制御
- **デバッグモード対応**: `kDebugMode`を使用したデバッグ専用ログ出力

## Getting started

pubspec.yaml に依存関係を追加してください：

```yaml
dependencies:
  armyknife_logger_flutter: ^1.0.0
```

## Usage

### 基本的な使用方法

```dart
import 'package:armyknife_logger_flutter/armyknife_logger_flutter.dart';

// タグを指定してLoggerを生成
final logger = Logger.tag('MyApp');

// 各レベルのログ出力
logger.i('アプリケーションが開始されました');
logger.d('デバッグ情報');
logger.w('警告メッセージ');
logger.e('エラーが発生しました', error, stackTrace);
```

### Flutter 固有の使用方法

```dart
import 'package:flutter/foundation.dart';
import 'package:armyknife_logger_flutter/armyknife_logger_flutter.dart';

// デバッグモードでのみログ出力
final logger = Logger.drop(
  Logger.tag('MyWidget'),
  drop: !kDebugMode,
);

// Widget内での使用例
class MyWidget extends StatelessWidget {
  static final _logger = Logger.of(MyWidget);

  @override
  Widget build(BuildContext context) {
    _logger.d('ウィジェットがビルドされました');
    return Container();
  }
}
```

### 異なる Logger 生成方法

```dart
// 型を指定してLoggerを生成
final logger = Logger.of(MyClass);

// 現在のファイル名をタグとしてLoggerを生成
final logger = Logger.file();

// カスタムコールバック関数を指定してLoggerを生成
final logger = Logger.create(
  info: (message) => debugPrint('INFO: $message'),
  debug: (message) => debugPrint('DEBUG: $message'),
  warning: (message) => debugPrint('WARNING: $message'),
  error: (message, [error, stackTrace]) => debugPrint('ERROR: $message'),
);
```

## Additional information

このライブラリは`logger` package（pub.dev 上の人気のログライブラリ）をベースとしており、Flutter 固有の最適化が施されています。iOS、Android、その他のプラットフォームに応じて、色付け、絵文字、フォーマットが最適化されます。

Flutter 以外の環境では、対応する実装パッケージを使用してください：

- **armyknife_logger_grinder**: Grinder ビルドツール用

バグ報告や機能リクエストは、[GitHub repository](https://github.com/eaglesakura/flutter_armyknife/)でお受けしています。
