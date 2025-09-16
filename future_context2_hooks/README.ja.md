Flutter の FutureContext と Flutter Hooks を統合し、
Widget のライフサイクルと非同期処理を安全に連携するためのライブラリである。

## Features

- **FutureContext ライフサイクル連携**: Widget のライフサイクルと FutureContext を自動連携
- **自動リソース管理**: Widget 破棄時に FutureContext を自動的にクローズ
- **メモ化サポート**: keys パラメータによる FutureContext の再利用制御

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  future_context2_hooks: ^2.0.0
```

## Usage

Flutter Hooks を使って FutureContext を Widget のライフサイクルに連携させる：

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:future_context2_hooks/future_context2_hooks.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget のライフサイクルと連携した FutureContext
    final futureContext = useFutureContext();

    // 非同期処理を実行
    useEffect(() {
      // futureContext を使った非同期処理
      futureContext.suspend(() async {
        // 何らかの非同期処理
        await Future.delayed(Duration(seconds: 1));
        print('非同期処理完了');
      });
      
      return null; // Widget破棄時にfutureContextは自動的にクローズされる
    }, []);

    return Container(
      child: Text('FutureContext を使用中'),
    );
  }
}

```

### パラメータによる制御

```dart
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // タグ付きの FutureContext（デバッグ時に便利）
    final futureContext = useFutureContext(
      tag: 'MyWidget',
    );

    // keys による再利用制御
    final userId = ref.watch(userIdProvider);
    final userContext = useFutureContext(
      tag: 'UserData',
      keys: [userId], // userIdが変わったときのみ新しいFutureContextを作成
    );

    return Container();
  }
}
```

## Additional information

このパッケージは FutureContext と Flutter Hooks の統合を簡単にするために作られた。
Widget のライフサイクルに合わせた非同期処理の管理により、メモリリークや予期しない副作用を防ぐことができる。

バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
