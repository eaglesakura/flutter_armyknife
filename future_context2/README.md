Flutter で Kotlin coroutines のような **キャンセル可能な非同期処理** を実現するライブラリです。
Dart には非同期処理のキャンセル機能が標準で提供されていないため、このライブラリがその機能を提供します。

## Features

- **キャンセル可能な非同期処理**: `FutureContext.suspend()` を使用して非同期処理をキャンセル可能にします
- **親子関係とグループ化**: 複数の Context を階層化やグループ化して管理できます
- **タイムアウト処理**: 指定時間での自動タイムアウト処理をサポートします
- **拡張機能**: `withContext()` や `withContextStream()` による簡単な Context 管理
- **デバッグサポート**: タグ付き Context 管理とデバッグ出力機能

## Getting started

`pubspec.yaml` にライブラリを追加してください：

```yaml
dependencies:
  future_context2: ^1.0.0
```

## Usage

### 基本的な使用方法

```dart
import 'package:future_context2/future_context2.dart';

// FutureContext を作成
final context = FutureContext();

try {
  // キャンセル可能な非同期処理を実行
  final result = await context.suspend((context) async {
    await Future.delayed(Duration(seconds: 2));
    return 'completed';
  });

  print(result); // 'completed'
} on CancellationException {
  print('処理がキャンセルされました');
} finally {
  // Context を必ずクローズ
  await context.close();
}
```

### キャンセル処理

```dart
final context = FutureContext();

// 1秒後にキャンセル
Timer(Duration(seconds: 1), () async {
  await context.close();
});

try {
  await context.suspend((context) async {
    // 長時間の処理（10秒）
    await context.delayed(Duration(seconds: 10));
  });
} on CancellationException {
  print('1秒でキャンセルされました');
}
```

### 親子関係とグループ化

```dart
final parentContext = FutureContext();
final childContext = FutureContext.child(parentContext);

// 複数のContextをグループ化
final groupContext = FutureContext.group([parentContext, childContext]);

// 親がキャンセルされると子も自動的にキャンセル
await parentContext.close();
```

### タイムアウト処理

```dart
final context = FutureContext();

try {
  await context.withTimeout(
    Duration(seconds: 5),
    (context) async {
      // 5秒でタイムアウト
      await someVeryLongOperation();
    },
  );
} on TimeoutException {
  print('5秒でタイムアウトしました');
}
```

### 拡張機能の使用

```dart
// withContext でContext管理を簡素化
final result = await withContext(
  [
    WithContextTag('MyOperation'),
    WithContextTimeout(Duration(seconds: 30)),
  ],
  (context) async {
    return await heavyOperation();
  },
);
```

## Additional information

このライブラリは [flutter_future_context](https://github.com/vivitainc/flutter_future_context) の改良版です。

**主な改良点:**

- パフォーマンスの向上
- より直感的な API 設計
- 拡張機能の充実
- デバッグサポートの強化

**contribute について:**
バグ報告や機能要求は [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues) にお願いします。
