<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Task Queue

順番を保ったタスク実行を可能にする軽量なキューイングシステムを提供するFlutterパッケージです。

## 機能

- 追加した順番にタスクを実行
- 同期処理のシンプルな実装
- 非同期タスクの順序付き実行
- タスクの完了を待機する機能

## 導入方法

`pubspec.yaml`に依存関係を追加します：

```yaml
dependencies:
  task_queue: ^1.0.0
```

パッケージをインポートします：

```dart
import 'package:armyknife_task_queue/armyknife_task_queue.dart';
```

## 使用方法

### 基本的な使い方

```dart
// TaskQueueのインスタンスを作成
final taskQueue = TaskQueue();

// タスクをキューに追加
await taskQueue.queue(() async {
  // 最初に実行されるタスク
  await Future.delayed(Duration(seconds: 1));
  return '最初のタスク完了';
});

// 別のタスクを追加（前のタスクが完了するまで実行されない）
final result = await taskQueue.queue(() async {
  // 2番目に実行されるタスク
  await Future.delayed(Duration(seconds: 1));
  return '2番目のタスク完了';
});

print(result); // '2番目のタスク完了'と出力
```

### すべてのタスクの完了を待機

```dart
// 複数のタスクを追加
for (int i = 0; i < 5; i++) {
  taskQueue.queue(() async {
    await Future.delayed(Duration(seconds: 1));
    print('タスク $i 完了');
  });
}

// すべてのタスクが完了するまで待機
await taskQueue.join();
print('すべてのタスク完了');
```

### キューの状態確認

```dart
if (taskQueue.isEmpty) {
  print('実行待ちのタスクはありません');
}

if (taskQueue.isNotEmpty) {
  print('まだ実行待ちのタスクがあります');
}
```

## その他の情報

- このパッケージは[flutter_armyknife](https://github.com/eaglesakura/flutter_armyknife)の一部です
- 問題報告やフィードバックは[GitHubリポジトリ](https://github.com/eaglesakura/flutter_armyknife/task_queue)で行えます
