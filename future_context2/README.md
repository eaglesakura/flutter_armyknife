A library that provides **cancellable asynchronous operations** similar to Kotlin coroutines in Flutter.
Since Dart doesn't provide built-in cancellation functionality for asynchronous operations, this library fills that gap.

## Features

- **Cancellable asynchronous operations**: Make asynchronous operations cancellable using `FutureContext.suspend()`
- **Pause and resume functionality**: Support for pausing and resuming asynchronous operations using `FutureContext.resume()`
- **Parent-child relationships and grouping**: Manage multiple Contexts in hierarchical or grouped structures
- **Timeout handling**: Support for automatic timeout processing within specified time periods
- **Extension features**: Easy Context management with `withContext()` and `withContextStream()`
- **Debug support**: Tagged Context management and debug output functionality

## Getting started

Add the library to your `pubspec.yaml`:

```yaml
dependencies:
  future_context2: ^1.1.0
```

## Usage

### Basic Usage

```dart
import 'package:future_context2/future_context2.dart';

// Create a FutureContext
final context = FutureContext();

try {
  // Execute cancellable asynchronous operation
  final result = await context.suspend((context) async {
    await Future.delayed(Duration(seconds: 2));
    return 'completed';
  });

  print(result); // 'completed'
} on CancellationException {
  print('Operation was cancelled');
} finally {
  // Always close the Context
  await context.close();
}
```

### Cancellation

```dart
final context = FutureContext();

// Cancel after 1 second
Timer(Duration(seconds: 1), () async {
  await context.close();
});

try {
  await context.suspend((context) async {
    // Long-running operation (10 seconds)
    await context.delayed(Duration(seconds: 10));
  });
} on CancellationException {
  print('Cancelled after 1 second');
}
```

### Parent-child relationships and grouping

```dart
final parentContext = FutureContext();
final childContext = FutureContext.child(parentContext);

// Group multiple Contexts
final groupContext = FutureContext.group([parentContext, childContext]);

// When parent is cancelled, child is automatically cancelled
await parentContext.close();
```

### Timeout handling

```dart
final context = FutureContext();

try {
  await context.withTimeout(
    Duration(seconds: 5),
    (context) async {
      // Times out after 5 seconds
      await someVeryLongOperation();
    },
  );
} on TimeoutException {
  print('Timed out after 5 seconds');
}
```

### Using extension features

```dart
// Simplify Context management with withContext
final result = await withContext(
  [
    WithContextTag('MyOperation'),
    WithContextTimeout(Duration(seconds: 30)),
  ],
  (context) async {
    return await heavyOperation();
  },
);
```

### Pause and resume functionality

```dart
final context = FutureContext();

// Custom pause logic can be implemented
await context.suspend((context) async {
  // resume() is automatically called before execution, waiting for an executable state
  // Processes can be paused based on external conditions as needed
  await someConditionalOperation();
  return 'result';
});
```

## Additional information

This library is an improved version of [flutter_future_context](https://github.com/vivitainc/flutter_future_context).

**Key improvements:**

- Performance improvements
- More intuitive API design
- Enhanced extension features
- Strengthened debug support
- Support for pause and resume functionality

**About contributions:**
Please submit bug reports and feature requests to [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues).
