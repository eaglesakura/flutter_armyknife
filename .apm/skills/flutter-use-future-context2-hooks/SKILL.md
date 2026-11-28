---
name: flutter-use-future-context2-hooks
description: >-
  future_context2_hooks の利用ガイド。useFutureContext、Widget 破棄時の自動 close、
  HookWidget / HookConsumerWidget。「useFutureContext」「Hook で FutureContext」
  では必ず使う。FutureContext 本体の API は flutter-use-future-context2。
---
# future_context2_hooks / Hooks 連携

`FutureContext` を Flutter Hooks の寿命に結び、Widget 破棄時に自動 `close` する。

## いつ使うか

* HookWidget / HookConsumerWidget 内で FutureContext を持ち、破棄と同時にキャンセルしたい

## 使わないか

* Hooks を使わない層での FutureContext（→ `flutter-use-future-context2`）

## 主な使い方（Example）

```dart
final fc = useFutureContext(tag: 'Screen', keys: [id]);

useEffect(() {
  fc.suspend((ctx) async {
    await ctx.delayed(const Duration(seconds: 1));
  });
  return null; // close は hook 側
}, [fc]);
```

### 主要 API

* `useFutureContext({String? tag, List<Object?>? keys})`
* `keys == null` のときは `[]`（リビルドで再利用）

## 組み合わせ

* `future_context2`
* `flutter_hooks`
* HookConsumer 例を動かすなら別途 `hooks_riverpod` 等

## 解放

**手動 close 不要。** hook の effect cleanup が `context.close()` する。
`keys` 変更で新 Context 生成時、旧 Context も cleanup で close。

## 注意

* `suspend` の引数は `Future Function(FutureContext)`（README の引数なし例は不正確）
