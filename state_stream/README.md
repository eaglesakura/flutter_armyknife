# State Stream

Flutter/Dart アプリケーション向けの軽量で型安全な状態管理ライブラリです。

## 特徴

- **型安全な状態管理** - Dart の型システムを活用した安全な状態管理
- **リアクティブな更新** - RxDart ベースのリアクティブな状態更新メカニズム
- **スレッドセーフな操作** - 状態更新のためのロック機構を提供
- **簡潔な API** - シンプルで使いやすいインターフェース
- **軽量設計** - 最小限の依存関係で高性能

## インストール

```yaml
dependencies:
  state_stream: ^1.0.0
```

## 基本的な使い方

### 読み取り専用状態ストリーム

```dart
import 'package:state_stream/state_stream.dart';
import 'package:rxdart/rxdart.dart';

// BehaviorSubjectから読み取り専用のStateStreamを作成
final behaviorSubject = BehaviorSubject<int>.seeded(0);
final stateStream = StateStream.fromBehaviorSubject(behaviorSubject);

// 現在の状態を取得
print(stateStream.state); // 0

// 状態変更を監視
stateStream.stream.listen((value) {
  print('新しい値: $value');
});
```

### 更新可能な状態ストリーム

```dart
import 'package:state_stream/state_stream.dart';

// 更新可能な状態ストリームを作成
final counter = MutableStateStream<int>(0);

// 現在の状態を取得
print(counter.state); // 0

// 状態を安全に更新
await counter.updateWithLock((currentState, emitter) async {
  // 非同期処理も可能
  await Future.delayed(Duration(milliseconds: 100));

  // 新しい状態を発行
  await emitter.emit(currentState + 1);

  // 戻り値（必要に応じて）
  return null;
});

// 状態変更を監視
counter.stream.listen((value) {
  print('カウント: $value');
});

// 使用が終わったらリソースを解放
await counter.close();
```

### カスタムディスパッチャー

```dart
import 'package:state_stream/state_stream.dart';

// カスタムディスパッチャーを作成
final customDispatcher = Dispatcher<int>((update) async {
  // 更新前の処理
  print('状態を更新中...');

  // 実際の更新処理を実行
  final result = await update();

  // 更新後の処理
  print('状態更新完了');

  return result;
});

// カスタムディスパッチャーを使用
final counter = MutableStateStream<int>(
  0,
  dispatcher: customDispatcher,
);
```

## 高度な機能

### 状態ストリームの拡張

```dart
import 'package:state_stream/state_stream.dart';

final counter = MutableStateStream<int>(0);

// 状態が変更されるまで待機
final newValue = await counter.waitForUpdate();
print('新しい値: $newValue');

// 条件を満たすまで待機
final evenValue = await counter.waitForWhere((value) => value % 2 == 0);
print('偶数の値: $evenValue');
```

### リソース管理

```dart
import 'package:state_stream/state_stream.dart';

// クローズ時のコールバックを指定
final counter = MutableStateStream<int>(
  0,
  onClose: (finalState) async {
    print('最終状態: $finalState');
    // クリーンアップ処理
  },
);

// 状態ストリームが有効かチェック
if (counter.isNotClosed) {
  await counter.updateWithLock((state, emitter) async {
    await emitter.emit(state + 1);
    return null;
  });
}

// リソースを解放
await counter.close();
```

## Riverpod との連携

Riverpod との連携機能は、別パッケージとして提供されています：

```yaml
dependencies:
  state_stream: ^1.0.0
  state_stream_riverpod: ^1.0.0
```

詳細は [state_stream_riverpod](https://pub.dev/packages/state_stream_riverpod) パッケージを参照してください。

## ライセンス

MIT License
