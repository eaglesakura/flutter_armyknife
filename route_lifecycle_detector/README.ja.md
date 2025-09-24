Navigator/ModalRoute/BuildContext のライフサイクルを検出する軽量なライブラリです。
**複数の非同期処理により発生するダイアログの多重表示問題**を解決し、適切なタイミングでUIを表示できるようにします。

## 解決する問題

非同期処理が複数実行される際に発生する典型的な問題：

1. **画面Aで重い処理が2個並行実行される**
2. **処理1が完了し、画面Bが開かれる**  
3. **処理2が完了し、画面Bの上にダイアログが表示されてしまう**

このライブラリを使用することで、画面Bが閉じて画面Aに戻るまでダイアログの表示を自動的に遅延できます。

## Features

- **ダイアログ多重表示の防止**: Route が非アクティブな間はUI表示を遅延
- **詳細なライフサイクル状態の検出**: Route の現在の状態（active/inactive/building/destroyed）とアプリのフォアグラウンド/バックグラウンド状態をリアルタイムで取得
- **Stream ベースの監視**: Route のライフサイクル変化を Stream で監視
- **型安全な状態管理**: Freezed による sealed class で型安全なパターンマッチングが可能
- **柔軟な待機機能**: カスタム条件でライフサイクル状態の変化を待機
- **軽量設計**: 最小限の依存関係とパフォーマンスオーバーヘッド

## Getting started

`pubspec.yaml` にライブラリを追加してください：

```yaml
dependencies:
  route_lifecycle_detector: ^1.1.0
```

MaterialApp に RouteLifecycleDetector のオブザーバーを追加してください：

```dart
import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

MaterialApp(
  navigatorObservers: [
    RouteLifecycleDetector.navigatorObserver,
  ],
)
```

## Usage

### 問題の例: ダイアログの多重表示

```dart
// 悪い例: 複数の非同期処理により意図しないダイアログの多重表示
class BadExamplePage extends StatefulWidget {
  @override
  _BadExamplePageState createState() => _BadExamplePageState();
}

class _BadExamplePageState extends State<BadExamplePage> {
  @override
  void initState() {
    super.initState();
    
    // 重い処理1: 2秒後に画面Bを開く
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PageB()));
    });
    
    // 重い処理2: 3秒後にダイアログを開く（問題が発生！）
    Future.delayed(Duration(seconds: 3), () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(title: Text('タスク2完了')),
      ); // 画面Bの上にダイアログが表示されてしまう
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(/*...*/);
}
```

### 解決策: ライフサイクルを考慮した処理

```dart
import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

class GoodExamplePage extends StatefulWidget {
  @override
  _GoodExamplePageState createState() => _GoodExamplePageState();
}

class _GoodExamplePageState extends State<GoodExamplePage> {
  @override
  void initState() {
    super.initState();
    
    // 重い処理1: 2秒後に画面Bを開く
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => PageB()));
    });
    
    // 重い処理2: 3秒後にダイアログを開く（ライフサイクルを考慮）
    Future.delayed(Duration(seconds: 3), () async {
      // Route が active 状態になるまで待機
      final lifecycle = await context.waitLifecycleWith(
        (lifecycle) => lifecycle is RouteLifecycleActive,
      );
      
      if (lifecycle is RouteLifecycleActive && mounted) {
        // 画面が前面に戻ってからダイアログを表示
        showDialog(
          context: context,
          builder: (_) => AlertDialog(title: Text('タスク2完了')),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(/*...*/);
}
```

### 現在のライフサイクル状態の取得

```dart
// 現在のライフサイクル状態を確認してからダイアログを表示
void showDialogSafely(BuildContext context) {
  final lifecycle = RouteLifecycle.of(context);
  
  if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
    // Route が最前面かつアプリがフォアグラウンドの場合のみダイアログを表示
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('安全に表示されました')),
    );
  } else {
    // Route が非アクティブまたはアプリがバックグラウンドの場合は表示を遅延
    print('Route が非アクティブまたはアプリがバックグラウンドのため、ダイアログ表示を遅延します');
  }
}
```

### Stream による監視

```dart
// ライフサイクルの変化を監視してダイアログ表示を制御
class SmartDialogController {
  StreamSubscription? _subscription;
  final List<VoidCallback> _pendingDialogs = [];
  
  void startListening(BuildContext context) {
    _subscription = RouteLifecycle.streamOf(context).listen((lifecycle) {
      if (lifecycle is RouteLifecycleActive && 
          lifecycle.isForeground && 
          _pendingDialogs.isNotEmpty) {
        // Route が前面に戻り、アプリがフォアグラウンドの時に保留中のダイアログを表示
        final dialogs = List<VoidCallback>.from(_pendingDialogs);
        _pendingDialogs.clear();
        
        for (final showDialog in dialogs) {
          showDialog();
        }
      }
    });
  }
  
  void showDialogWhenActive(BuildContext context, WidgetBuilder builder) {
    final lifecycle = RouteLifecycle.of(context);
    if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
      // 即座に表示
      showDialog(context: context, builder: builder);
    } else {
      // 後で表示するために保留
      _pendingDialogs.add(() => showDialog(context: context, builder: builder));
    }
  }
  
  void dispose() {
    _subscription?.cancel();
    _pendingDialogs.clear();
  }
}
```

### ライフサイクルの待機

```dart
// Route が active かつフォアグラウンドになるまで待機
try {
  final result = await context.waitLifecycleWith(
    (lifecycle) => lifecycle is RouteLifecycleActive && lifecycle.isForeground,
  );
  // Route が再開された
  print('Route が再開されました: $result');
} on BadLifecycleException catch (e) {
  // Route が破棄されるなど、期待した状態に到達できなかった場合
  print('期待した状態に到達できませんでした: ${e.latestLifecycle}');
}
```

### 実用的な使用例

ダイアログが開いている間は処理を停止し、ダイアログが閉じたら処理を再開する例：

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  StreamSubscription? _subscription;
  
  @override
  void initState() {
    super.initState();
    _startProcessing();
  }
  
  void _startProcessing() {
    _subscription = RouteLifecycle.streamOf(context).listen((lifecycle) {
      if (lifecycle is RouteLifecycleActive && lifecycle.isForeground) {
        // Route が前面に来て、アプリがフォアグラウンドのときだけ処理を実行
        _performBackgroundTask();
      }
    });
  }
  
  void _performBackgroundTask() {
    // バックグラウンドタスクの実行
    print('タスクを実行中...');
  }
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // ダイアログを表示
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Text('ダイアログ'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('閉じる'),
                  ),
                ],
              ),
            );
            // ダイアログが閉じられた後、自動的に処理が再開される
          },
          child: Text('ダイアログを開く'),
        ),
      ),
    );
  }
}
```

## ライフサイクル状態

| 状態 | 説明 | ダイアログ表示の推奨 |
|------|------|-------------|
| `RouteLifecycleActive(isForeground: true)` | アプリが前面にあり、Route がスタックの最上位にある | 🟢 安全に表示可能 |
| `RouteLifecycleActive(isForeground: false)` | Route はスタックの最上位だが、アプリがバックグラウンドにある | 🔴 表示を遅延有無を検討すべき |
| `RouteLifecycleInactive` | Route がスタックの最上位ではない | 🔴 表示を遅延すべき |
| `RouteLifecycleBuilding` | Widget ビルド中であり、まだ Route が生成されていない | 🔴 表示不可 |
| `RouteLifecycleDestroyed` | Route が破棄されている | 🔴 表示不可 |

**注意:** `isForeground` プロパティにより、アプリのフォアグラウンド/バックグラウンド状態を細かく制御できるようになりました。

## Additional information

このライブラリは Flutter の NavigatorObserver と flutter_fgbg を組み合わせて、
Route のライフサイクルを正確に追跡します。

**主な利点:**

- ダイアログや画面遷移による意図しない処理の実行を防止
- アプリのフォアグラウンド/バックグラウンド状態を考慮した制御
- Stream ベースの反応的なプログラミングサポート

**contribute について:**
バグ報告や機能要求は [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues) にお願いします。
