# riverpod_container_builder

A library that builds Riverpod `ProviderContainer` instances with a builder pattern.
It supports provider injection (`inject` / `injectValue`) and bulk override registration.

## Features

- **ProviderContainer builder**: Build dependency trees efficiently
- **DI-oriented inject**: Inject implementations or fixed values into interface providers
- **Bulk overrides**: `addOverride` / `addOverrides`
- **Parent containers**: Scope construction via `build(parent:)`

## Getting started

Add the following dependency to your `pubspec.yaml`:

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

// With a parent container
final child = ProviderContainerBuilder().build(parent: container);
```

For async initialization and disposal, add
`ProviderContainerAsyncHelper.inject()` from
[`riverpod_container_async`](../riverpod_container_async/) via `addOverrides`.

```dart
import 'package:riverpod_container_async/riverpod_container_async.dart';

final container = ProviderContainerBuilder()
    .addOverrides(ProviderContainerAsyncHelper.inject())
    .build();
```

## Additional information

Bug reports and feature requests are welcome on
[GitHub](https://github.com/eaglesakura/flutter_armyknife).
