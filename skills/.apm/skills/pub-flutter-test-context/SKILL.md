---
name: pub-flutter-test-context
description: >-
  armyknife_test_context（ディレクトリ test_context）の利用ガイド。TestContext.current /
  value / valueOf、テスト終了時 tearDown。「テストごとに一時 DB を」「TestContext」
  では必ず使う。pub 名は armyknife_test_context。riverpod_container_async_test の
  testReady とは役割が異なる。
---
# armyknife_test_context / テスト用コンテキスト

Unit Test ごとに 1 インスタンスが保証されるキーバリュー型コンテキスト。
ディレクトリ名は `test_context`、**pub 名は `armyknife_test_context`**。

## いつ使うか

* テスト間で共有したくない一時データ・リソースを、tearDown で片付けたい

## 使わないか

* Riverpod コンテナの非同期準備（→ `pub-flutter-riverpod-container-async-test`）
* 本番アプリの DI

## 主な使い方（Example）

```dart
import 'package:armyknife_test_context/armyknife_test_context.dart';

test('example', () async {
  final ctx = TestContext.current();
  final db = ctx.value<FakeDb>(
    'db',
    (_) => FakeDb(),
    onTearDown: (_, db) async => db.close(),
  );
  expect(ctx.valueOf<FakeDb>('db'), same(db));
});
```

### 主要 API

* `TestContext.current()` — 未作成なら生成し `addTearDown` でクリア
* `value(key, factory, {onTearDown})` — 初回のみ factory
* `valueOf(key)` — 未登録は `StateError`

## 組み合わせ

* `flutter_test`（`addTearDown`）

## 解放

公開 `dispose` は**なし**。インスタンス破棄と `onTearDown` は `flutter_test` の tearDown に委譲。
リソース解放は `onTearDown` に書く。

## 注意

* import は `package:armyknife_test_context/armyknife_test_context.dart`（README の別パスは誤り）
* 同一 test 内の `current()` はシングルトン。キー重複時は初回 factory のみ
