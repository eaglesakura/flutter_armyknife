# riverpod_container_builder

Riverpod の `ProviderContainer` を Builder パターンで組み立てるライブラリである。
Provider の差し替え（`inject` / `injectValue`）や Override の一括登録をサポートする。

## Features

- **ProviderContainer ビルダー**: 依存関係を効率的に構築するビルダーパターン
- **DI 向け inject**: インターフェース Provider への実装注入 / 固定値注入
- **Override 一括登録**: `addOverride` / `addOverrides`
- **親子 Container**: `build(parent:)` によるスコープ構築

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  riverpod_container_builder: ^1.0.0
```

## Usage

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_container_builder/riverpod_container_builder.dart';

final stubProvider = Provider<String>((ref) => 'stub');
final implProvider = Provider<String>((ref) => 'impl');
final valueProvider = Provider<int>((ref) => 0);

final container = ProviderContainerBuilder()
    .inject(stubProvider, implProvider)
    .injectValue(valueProvider, 42)
    .build();

// 親 Container を指定する場合
final child = ProviderContainerBuilder().build(parent: container);
```

非同期初期化・解放が必要な場合は、別パッケージ
[`riverpod_container_async`](../riverpod_container_async/) の
`ProviderContainerAsyncHelper.inject()` を `addOverrides` で追加する。

```dart
import 'package:riverpod_container_async/riverpod_container_async.dart';

final container = ProviderContainerBuilder()
    .addOverrides(ProviderContainerAsyncHelper.inject())
    .build();
```

## Additional information

バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
