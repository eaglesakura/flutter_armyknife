# future_context2_hooks

A library that integrates Flutter's FutureContext with Flutter Hooks to safely coordinate Widget lifecycle and asynchronous processing.

## Features

- **FutureContext Lifecycle Integration**: Automatically links Widget lifecycle with FutureContext
- **Automatic Resource Management**: Automatically closes FutureContext when Widget is disposed
- **Memoization Support**: Control FutureContext reuse through keys parameter

## Getting started

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  future_context2_hooks: ^2.0.0
```

## Usage

Use Flutter Hooks to integrate FutureContext with Widget lifecycle:

```dart
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:future_context2_hooks/future_context2_hooks.dart';

class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FutureContext linked with Widget lifecycle
    final futureContext = useFutureContext();

    // Execute asynchronous processing
    useEffect(() {
      // Asynchronous processing using futureContext
      futureContext.suspend(() async {
        // Some asynchronous processing
        await Future.delayed(Duration(seconds: 1));
        print('Asynchronous processing completed');
      });
      
      return null; // futureContext is automatically closed when Widget is disposed
    }, []);

    return Container(
      child: Text('Using FutureContext'),
    );
  }
}

```

### Parameter Control

```dart
class MyWidget extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tagged FutureContext (useful for debugging)
    final futureContext = useFutureContext(
      tag: 'MyWidget',
    );

    // Reuse control with keys
    final userId = ref.watch(userIdProvider);
    final userContext = useFutureContext(
      tag: 'UserData',
      keys: [userId], // Create new FutureContext only when userId changes
    );

    return Container();
  }
}
```

## Additional information

This package was created to simplify the integration of FutureContext and Flutter Hooks.
By managing asynchronous processing according to Widget lifecycle, it prevents memory leaks and unexpected side effects.

Bug reports and feature requests are accepted at [GitHub](https://github.com/eaglesakura/flutter_armyknife).
