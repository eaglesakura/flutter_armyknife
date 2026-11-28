---
name: flutter-use-riverpod-container-builder
description: >-
  riverpod_container_builder の利用ガイド。ProviderContainerBuilder による
  DI / Override 構築、inject / injectValue / addOverrides / build(parent:)。
  「ProviderContainer を Builder で」「DI オーバーライドを組み立てて」では必ず使う。
  非同期コンテナ寿命は flutter-use-riverpod-container-async、
  useEventStream は armyknife_riverpodx（別）。単なる Riverpod 規約のみでは使わない。
---
# riverpod_container_builder / ProviderContainer ビルダー

Riverpod の `ProviderContainer` を Builder で組み立て、Provider 差し替えと Override 登録をまとめる。

## いつ使うか

* アプリ起動やテストで複数 Provider の Override を組み立てたい
* インターフェース Provider に実装 / 固定値を注入したい
* 親 Container 付きのスコープを作りたい

## 使わないか

* 非同期初期化待ち / `disposeAsync`（→ `flutter-use-riverpod-container-async`）
* Stream のフレーム遅延監視だけ（→ `armyknife_riverpodx` の `useEventStream`）
* Override 無しの素の `ProviderContainer()` で足りるとき

## 主な使い方（Example）

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_container_builder/riverpod_container_builder.dart';

final stubProvider = Provider<String>((ref) => 'stub');
final implProvider = Provider<String>((ref) => 'impl');
final valueProvider = Provider<int>((ref) => 0);

final container = ProviderContainerBuilder()
    .inject(stubProvider, implProvider)
    .injectValue(valueProvider, 42)
    .addOverrides([/* other overrides */])
    .build();

final child = ProviderContainerBuilder().build(parent: container);
```

### 主要 API

* `add` / `override` — Provider 単位の Override（同一 Provider は後勝ち）
* `addOverride` / `addOverrides` — 汎用 Override（キャッシュしない）
* `inject` / `injectValue` — DI 向け差し替え
* `build({parent, overrides})` — `ProviderContainer` 生成
* `overrides` getter — 登録済み一覧

## 組み合わせ

* `flutter_riverpod` / `riverpod`（^3）
* 非同期寿命が必要なら `riverpod_container_async` を別途依存し、
  `addOverrides(ProviderContainerAsyncHelper.inject())` する

## 解放

**不要**（Builder 自体に dispose はない）。生成した `ProviderContainer` は呼び出し側で `dispose`（または async 側の `disposeAsync`）する。

## 注意

* `ProviderContainerAsyncHelper` は本パッケージに含まれない。手動で `addOverrides` する
* `armyknife_riverpodx` からの `ProviderContainerBuilder` は Deprecated。本パッケージを直接 import する
* import は `package:riverpod_container_builder/riverpod_container_builder.dart`
