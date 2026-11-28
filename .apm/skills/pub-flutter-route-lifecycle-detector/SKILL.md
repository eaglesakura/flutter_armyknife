---
name: pub-flutter-route-lifecycle-detector
description: >-
  route_lifecycle_detector の利用ガイド。NavigatorObserver 登録、RouteLifecycle、
  waitLifecycleWith、非アクティブ時のダイアログ多重表示防止。「画面がアクティブか
  確認してから showDialog」「RouteLifecycle」では必ず使う。一般的な Navigator
  遷移設計のみ、Riverpod 状態管理のみでは使わない。
---
# route_lifecycle_detector / Route 寿命

`NavigatorObserver` と前後台検知で Route の active / inactive / destroyed を知り、非同期後の UI 表示を安全にする。

## いつ使うか

* 非同期完了後にダイアログ等を出すが、その間に別画面へ遷移している可能性がある
* 「前面かつアクティブ」になるまで待ちたい

## 使わないか

* 単なる画面遷移設計（go_router 等のルート定義だけ）
* アプリ全体のプロセス kill 検知だけ

## 主な使い方（Example）

```dart
MaterialApp(
  navigatorObservers: [RouteLifecycleDetector.navigatorObserver],
  // ...
);

final lifecycle = await context.waitLifecycleWith(
  (l) => l is RouteLifecycleActive && l.isForeground,
);
if (lifecycle is RouteLifecycleActive && context.mounted) {
  showDialog(context: context, builder: (_) => const ExampleDialog());
}
```

### 主要 API

* `RouteLifecycleDetector.navigatorObserver` — `MaterialApp.navigatorObservers` に登録
* `RouteLifecycle`: `active` / `building` / `inactive` / `destroyed`（各 `isForeground`）
* `RouteLifecycle.of` / `streamOf`
* `context.waitLifecycleWith(test)` — 条件未達のまま `destroyed` なら `BadLifecycleException`

## 組み合わせ

* Flutter `Navigator` / widgets
* `flutter_fgbg`, `rxdart`

## 解放

Detector 自体の dispose API は**不要**。`streamOf` を手動購読する場合は `StreamSubscription.cancel`。
`destroyed` で Stream は閉じる。

## 注意

* Observer 未登録だと Route 変化通知が不完全
* `waitLifecycleWith` は条件未達のまま終了すると例外
