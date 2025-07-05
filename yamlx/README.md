YAML ファイルをシンプルな Map 構造として読み込むためのライブラリ。
標準の yaml ライブラリをベースに、より使いやすい API を提供します。

## Features

- YAML ファイルを Map<String, dynamic>として読み込み
- 複数の YAML ファイルをマージして読み込み
- 特定のパスから値を取得する機能
- 必須値の取得と検証

## Getting started

`pubspec.yaml`に以下を追加してください：

```yaml
dependencies:
  armyknife_yamlx: ^1.0.0
```

## Usage

### 基本的な使い方

```dart
import 'dart:io';
import 'package:armyknife_yamlx/armyknife_yamlx.dart';

// YAMLファイルを読み込み
final yamlFile = File('config.yaml');
final config = YamlX.parse(yamlFile);

// 特定のパスから値を取得
final value = YamlX.find<String>(config, ['database', 'host']);

// 必須値を取得（存在しない場合は例外）
final port = YamlX.require<int>(config, ['database', 'port']);

// 複数のYAMLファイルをマージ
final configs = YamlX.parseWithMerge([
  File('base.yaml'),
  File('override.yaml'),
]);
```

## Additional information

このライブラリは flutter_armyknife プロジェクトの一部として開発されています。
バグ報告や機能要求は GitHub リポジトリまでお願いします。
