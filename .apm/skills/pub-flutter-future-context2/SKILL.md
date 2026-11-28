---
name: pub-flutter-future-context2
description: >-
  future_context2 の利用ガイド。FutureContext、suspend / close / withContext、
  親子・グループ・タイムアウト、CancellationException（async_notify2）。
  「キャンセル可能な非同期」「画面離脱で Future を止めて」では必ず使う。
  Hooks 自動 close は pub-flutter-future-context2-hooks。短いワンショット Future
  だけなら使わない。
---
# future_context2 / キャンセル可能コンテキスト

Kotlin Coroutine 風のキャンセル可能な非同期実行コンテキスト。

## いつ使うか

* 画面離脱や上位キャンセルで長時間非同期を止めたい
* 階層的なキャンセル伝播が欲しい

## 使わないか

* キャンセル不要の短い Future
* Hook 寿命への自動結び付けだけ（→ `pub-flutter-future-context2-hooks`）

## 主な使い方（Example）

```dart
import 'package:async_notify2/async_notify2.dart';
import 'package:future_context2/future_context2.dart';

final context = FutureContext();
try {
  await context.suspend((ctx) async {
    await ctx.delayed(const Duration(seconds: 2));
    return 'ok';
  });
} on CancellationException {
  // ...
} finally {
  await context.close();
}

await withContext(
  [WithContextTag('op'), WithContextTimeout(Duration(seconds: 30))],
  (ctx) => heavy(ctx),
);
```

### 主要 API

* `FutureContext` / `.child` / `.group`
* `suspend` / `delayed` / `withTimeout` / `close` / `isActive` / `isCanceled`
* `withContext([...], block)` — Context / Request / Tag / Timeout を混ぜて指定可

## 組み合わせ

* `async_notify2`（`CancellationException` — **本パッケージは re-export しない**）
* Hooks: `future_context2_hooks`
* 内部: `rxdart`, `armyknife_streams` 等

## 解放

**`close()` 推奨。** 親 close で子もキャンセル扱い。
`withContext` が新規 / group を作った場合は finally で自動 close。既存 Context を 1 つ渡しただけなら close しない。

## 注意

* README 例だけ import して `CancellationException` を catch すると解決できない → `async_notify2` を別 import
* `suspend` はオーバーヘッドがある。長い・キャンセルが必要な処理向き
* `withContext` にネストした Iterable を渡すと `ArgumentError`
* タイムアウトは `TimeoutException`
