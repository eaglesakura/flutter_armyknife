Dart のランタイムに便利な関数と拡張機能を提供するライブラリです。非同期処理、コレクション操作、型判定、プラットフォーム判定などの機能を提供し、Dart コードの記述を簡潔にします。

## Features

- **便利な関数群**: Future 操作、型判定、プラットフォーム判定
- **Iterable 拡張機能**: 重複排除、Map 変換
- **Map 操作ユーティリティ**: 再帰的なマージ機能
- **スタックトレース操作**: ファイル名取得
- **コレクション構築関数**: Map、List、Set 構築のビルダー

## Getting started

pubspec.yaml に以下を追加してください：

```yaml
dependencies:
  armyknife_dartx: ^1.0.0
```

## Usage

### 便利な関数群

```dart
import 'package:armyknife_dartx/armyknife_dartx.dart';

// Future.delayedの糖衣構文
await delayed(Duration(milliseconds: 100));

// 実行ループ1イテレーションをスキップ
await nop();

// 型の一致を確認
if (typeEquals<String, String>()) {
  print('同じ型です');
}

// Webプラットフォームかどうかの判定
if (kIsWebCompat) {
  print('Webプラットフォームです');
}
```

### Iterable 拡張機能

```dart
// 重複を排除
final unique = [1, 2, 2, 3, 3, 4].distinctUnique();
print(unique); // [1, 2, 3, 4]

// MapEntryのIterableをMapに変換
final entries = [
  MapEntry('a', 1),
  MapEntry('b', 2),
];
final map = entries.toMap();
print(map); // {a: 1, b: 2}
```

### Map 操作ユーティリティ

```dart
// 2つのMapを再帰的にマージ
final merged = MapX.merge(
  {'a': 1, 'b': {'c': 2}},
  {'b': {'d': 3}, 'e': 4},
);
print(merged); // {a: 1, b: {c: 2, d: 3}, e: 4}
```

### コレクション構築関数

```dart
// Map構築
final map = buildMap<String, int>((map) {
  map['a'] = 1;
  map['b'] = 2;
});

// List構築
final list = buildList<String>((list) {
  list.add('item1');
  list.add('item2');
});

// Set構築
final set = buildSet<int>((set) {
  set.add(1);
  set.add(2);
});
```

## Additional information

このライブラリは Flutter Army Knife プロジェクトの一部です。

- **GitHub**: https://github.com/eaglesakura/flutter_armyknife
- **Issues**: バグ報告や機能要求は GitHub の Issues をご利用ください
- **ライセンス**: MIT License
