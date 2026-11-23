# armyknife_riverpodx

A support library for efficient state management in Flutter+Riverpod development.
It provides convenient utility functions including ProviderContainer construction support, safe Stream monitoring, and logical equality checking for list-type data.

## Features

- **Stream Hooks**: Safe Stream monitoring functionality for UI
- **List-type Properties**: Support for logical equality checking in Riverpod (deprecated; prefer `flutter_riverpod_watch_plus`)
- **ProviderContainer Builder**: Deprecated. Use [`riverpod_container_builder`](../riverpod_container_builder/)

## Getting started

Add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  armyknife_riverpodx: ^1.1.0
  # Add individually as needed
  flutter_hooks: ^0.21.2
  flutter_riverpod: ^2.6.1
  hooks_riverpod: ^2.6.1
  # Recommended as an alternative to ListSelectProperty
  flutter_riverpod_watch_plus: ^1.0.0
```

## Usage

Provides convenient features for Riverpod:

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

// Stream monitoring
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEventStream(
      () => someStream,
      (data) {
        // Process data safely
      },
    );

    return Container();
  }
}

// List-type properties (deprecated in v1.1.1)
// Use flutter_riverpod_watch_plus instead
final listProvider = StateProvider<List<String>>((ref) {
  return ['item1', 'item2', 'item3'];
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use watchBy() for efficient monitoring
    final items = ref.watchBy(listProvider, (list) => list);
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

## Migration 2.1.0 to 2.2.0

`ProviderContainerBuilder` has moved to [`riverpod_container_builder`](../riverpod_container_builder/).
Exporting it via `armyknife_riverpodx` is deprecated.

**Writing in 2.1.0 (deprecated):**

```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

final container = ProviderContainerBuilder()
    .inject(stubProvider, implementationProvider)
    .build();
```

**Writing in 2.2.0:**

```dart
import 'package:riverpod_container_builder/riverpod_container_builder.dart';

final container = ProviderContainerBuilder()
    .inject(stubProvider, implementationProvider)
    .injectValue(valueProvider, 42)
    .build();
```

```yaml
dependencies:
  riverpod_container_builder: ^1.0.0
```

## Migration 1.0.0 to 1.1.0

In version 1.1.0, the library structure was reorganized and functionality was separated into specialized packages.

### Major Changes

- Export of `riverpod` libraries has been discontinued
- `useFutureContext` functionality has been moved to [`future_context2_hooks`](../future_context2_hooks/) package
- Asynchronous processing functionality has been moved to [`riverpod_container_async`](../riverpod_container_async/) package
- Individual dependency library imports need to be added as necessary

### Import Changes

**Writing in 1.0.0:**

```dart
// All riverpod features available with one import
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureContext = useFutureContext();
    // flutter_hooks, flutter_riverpod, hooks_riverpod all available
    return Container();
  }
}
```

**Writing in 1.1.0:**

```dart
// Import required libraries individually
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:future_context2_hooks/future_context2_hooks.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureContext = useFutureContext(); // Provided by future_context2_hooks
    // Same functionality available
    return Container();
  }
}
```

### Asynchronous Processing Migration

**Writing in 1.0.0:**

```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
  ],
);

// Asynchronous initialization and disposal processing
await container.waitInitializeTasks();
await container.disposeAsync();
```

**Writing in 1.1.0:**

```dart
// Asynchronous processing functionality moved to separate package
import 'package:riverpod_container_async/riverpod_container_async.dart';
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
  ],
);

// Same API available
await container.waitInitializeTasks();
await container.disposeAsync();
```

## Migration 1.1.0 to 1.1.1

In version 1.1.1, `ListSelectProperty` has been deprecated and migrated to the more efficient and user-friendly [`flutter_riverpod_watch_plus`](../flutter_riverpod_watch_plus/) package.

### ListSelectProperty Migration

**Writing in 1.1.0 (deprecated):**

```dart
import 'package:armyknife_riverpodx/armyknife_riverpodx.dart';

// List state management using ListSelectProperty
final listProvider = StateProvider<ListSelectProperty<String>>((ref) {
  return ListSelectProperty(['item1', 'item2', 'item3']);
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listProperty = ref.watch(listProvider);
    final items = listProperty.requireList();
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

**Writing in 1.1.1 (recommended):**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';

// Handle List directly and monitor efficiently with watchBy()
final listProvider = StateProvider<List<String>>((ref) {
  return ['item1', 'item2', 'item3'];
});

class ListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // With watchBy(), no re-rendering when content is the same
    final items = ref.watchBy(listProvider, (list) => list);
    
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
    );
  }
}
```

### Required Dependencies

Add the following to `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod_watch_plus: ^1.0.0
```

### Migration Benefits

1. **Simpler API**: No need for wrapper classes, direct List handling
2. **Efficient State Monitoring**: Prevents unnecessary re-rendering with `watchBy()`
3. **Type Safety**: No need for exception-throwing methods like `requireList()`
4. **Flexibility**: Supports collections other than List (Map, Set)

## Additional information

This package was created to streamline state management in Flutter development.

> **Note:**
>
> - The ProviderContainer builder has been moved to the separate package [`riverpod_container_builder`](../riverpod_container_builder/).
> - Asynchronous initialization and disposal processing for ProviderContainer has been moved to the separate package [`riverpod_container_async`](../riverpod_container_async/).
> - FutureContext and Hooks integration functionality has been moved to the separate package [`future_context2_hooks`](../future_context2_hooks/).

Bug reports and feature requests are accepted at [GitHub](https://github.com/eaglesakura/flutter_armyknife).
