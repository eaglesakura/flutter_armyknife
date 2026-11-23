---
name: pub-flutter-flutter-riverpod-watch-plus
description: >-
  flutter_riverpod_watch_plus の利用ガイド。Ref / WidgetRef の watchBy、
  List/Map/Set の deep-equals 監視、内容同一時の不要再ビルド回避。
  「watchBy でリストを監視」「コレクションの内容比較で watch」では必ず使う。
  通常の ref.watch だけで足りるスカラー値、Riverpod 以外では使わない。
---
# flutter_riverpod_watch_plus / watchBy

`watch` が List / Map / Set で参照比較になる問題を、`watchBy` の deep-equals で抑える。

## いつ使うか

* Provider から取り出したコレクションを監視し、内容不変時の不要再描画を避けたい

## 使わないか

* `int` / `String` など通常の `ref.watch` で十分なとき
* Riverpod を使わない Widget

## 主な使い方（Example）

```dart
final list = ref.watchBy(listProvider, (v) => v);
final filtered = ref.watchBy(
  listProvider,
  (list) => list.where((e) => e.startsWith('a')).toList(),
);
```

### 主要 API

* `Ref.watchBy` / `WidgetRef.watchBy`
* `T watchBy<P, T>(ProviderListenable<P> provider, T Function(P) selector)`

## 組み合わせ

* `flutter_riverpod` / `riverpod`（^3）
* `collection`（内部の deep equality）

## 解放

**不要**（拡張メソッドのみ）。

## 注意

* Collection 以外でも使えるが、中間オブジェクト生成コストがある
* Riverpod 3 対応
