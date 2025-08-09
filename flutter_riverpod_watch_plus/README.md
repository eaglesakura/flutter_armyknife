A library that solves the problem of Riverpod's `Ref.watch()` not supporting deep-equals for Iterables and Maps.
It prevents unnecessary re-renders caused by reference comparison when watching collections (List, Map, Set) and enables efficient state management.

## Features

- **Deep Equals Support**: Efficient state watching with deep comparison for List, Map, and Set
- **Prevent Unnecessary Re-renders**: Avoids re-rendering when collection contents are the same
- **Extension Functions**: Easy usage through `Ref.watchBy()` and `WidgetRef.watchBy()`

## Getting started

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod_watch_plus: ^1.0.0
```

## Usage

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';

// Provider watching a regular List
final listProvider = StateProvider<List<String>>((ref) => ['a', 'b', 'c']);

// Traditional watching method (unnecessary re-renders due to reference comparison)
final badExample = Provider((ref) {
  final list = ref.watch(listProvider); // Re-renders even when content is the same
  return list.length;
});

// Using watchBy() for efficient watching (Deep Equals)
final goodExample = Provider((ref) {
  final list = ref.watchBy(listProvider, (value) => value); // No re-render when content is the same
  return list.length;
});

// Usage example in Widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watchBy() can also be used with WidgetRef
    final filteredList = ref.watchBy(
      listProvider,
      (list) => list.where((item) => item.startsWith('a')).toList(),
    );

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(filteredList[index]));
      },
    );
  }
}
```

## Additional information

This package extends Riverpod's `Ref.watch()` functionality to provide deep-equals support for collections.
It uses an intermediate object (WatchValue) to perform content comparison of collections and prevent unnecessary re-renders.
Bug reports and feature requests are accepted on [GitHub](https://github.com/eaglesakura/flutter_armyknife).
