# armyknife_logger_grinder

Grinder ビルドツール用のログライブラリ実装です。`armyknife_logger`の統一インターフェースを使用しながら、Grinder ビルドスクリプト向けに最適化されたログ出力を提供します。

## Features

- **Grinder 最適化**: Grinder ビルドツール向けに最適化されたログ出力
- **統一されたログインターフェース**: 4 つのログレベル（Debug, Info, Warning, Error）をサポート
- **ビルドスクリプト対応**: ビルドプロセスでの使用に適したフォーマット
- **柔軟な Logger 生成**: タグ、型、ファイル名、コールバック関数を指定して Logger を生成
- **ログ出力の抑制**: 条件に応じてログ出力を制御
- **コンソール出力最適化**: ターミナルでの視認性に優れたログ出力

## Getting started

pubspec.yaml に依存関係を追加してください：

```yaml
dependencies:
  armyknife_logger_grinder: ^1.0.0
```

## Usage

### 基本的な使用方法

```dart
import 'package:armyknife_logger_grinder/armyknife_logger_grinder.dart';

// タグを指定してLoggerを生成
final logger = Logger.tag('Build');

// 各レベルのログ出力
logger.i('ビルドプロセスが開始されました');
logger.d('デバッグ情報');
logger.w('警告メッセージ');
logger.e('ビルドエラーが発生しました', error, stackTrace);
```

### Grinder ビルドスクリプトでの使用例

```dart
import 'package:grinder/grinder.dart';
import 'package:armyknife_logger_grinder/armyknife_logger_grinder.dart';

final _logger = Logger.tag('Grinder');

@Task('Clean build artifacts')
void clean() {
  _logger.i('ビルド成果物をクリーンアップしています...');

  try {
    delete(getBuildDir());
    _logger.i('クリーンアップが完了しました');
  } catch (e, stackTrace) {
    _logger.e('クリーンアップに失敗しました', e, stackTrace);
    rethrow;
  }
}

@Task('Build application')
@Depends(clean)
void build() {
  _logger.i('アプリケーションをビルドしています...');

  // ビルドロジック
  _logger.i('ビルドが完了しました');
}
```

### 異なる Logger 生成方法

```dart
// 型を指定してLoggerを生成
final logger = Logger.of(MyBuildTask);

// 現在のファイル名をタグとしてLoggerを生成
final logger = Logger.file();

// カスタムコールバック関数を指定してLoggerを生成
final logger = Logger.create(
  info: (message) => print('INFO: $message'),
  debug: (message) => print('DEBUG: $message'),
  warning: (message) => print('WARNING: $message'),
  error: (message, [error, stackTrace]) => print('ERROR: $message'),
);
```

## Additional information

このライブラリは、Grinder ビルドツールでの使用に最適化されており、コンソール出力での視認性とビルドプロセスでの使いやすさを重視した設計になっています。

Flutter アプリケーションでは、対応する実装パッケージを使用してください：

- **armyknife_logger_flutter**: Flutter/Dart アプリケーション用

バグ報告や機能リクエストは、[GitHub repository](https://github.com/eaglesakura/flutter_armyknife/)でお受けしています。
