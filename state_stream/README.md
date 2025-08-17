# State Stream

A lightweight and type-safe state management library for Flutter/Dart applications.

## Features

- **Type-safe state management** - Safe state management leveraging Dart's type system
- **Reactive updates** - RxDart-based reactive state update mechanism
- **Thread-safe operations** - Provides locking mechanism for state updates
- **Concise API** - Simple and easy-to-use interface
- **Lightweight design** - High performance with minimal dependencies

## Installation

```yaml
dependencies:
  state_stream: ^1.0.0
```

## Basic Usage

### Read-only State Stream

```dart
import 'package:state_stream/state_stream.dart';
import 'package:rxdart/rxdart.dart';

// Create a read-only StateStream from BehaviorSubject
final behaviorSubject = BehaviorSubject<int>.seeded(0);
final stateStream = StateStream.fromBehaviorSubject(behaviorSubject);

// Get current state
print(stateStream.state); // 0

// Listen to state changes
stateStream.stream.listen((value) {
  print('New value: $value');
});
```

### Mutable State Stream

```dart
import 'package:state_stream/state_stream.dart';

// Create a mutable state stream
final counter = MutableStateStream<int>(0);

// Get current state
print(counter.state); // 0

// Safely update state
await counter.updateWithLock((currentState, emitter) async {
  // Asynchronous processing is also possible
  await Future.delayed(Duration(milliseconds: 100));

  // Emit new state
  await emitter.emit(currentState + 1);

  // Return value (if needed)
  return null;
});

// Listen to state changes
counter.stream.listen((value) {
  print('Count: $value');
});

// Release resources when done
await counter.close();
```

### Custom Dispatcher

```dart
import 'package:state_stream/state_stream.dart';

// Create custom dispatcher
final customDispatcher = Dispatcher<int>((update) async {
  // Pre-update processing
  print('Updating state...');

  // Execute actual update processing
  final result = await update();

  // Post-update processing
  print('State update completed');

  return result;
});

// Use custom dispatcher
final counter = MutableStateStream<int>(
  0,
  dispatcher: customDispatcher,
);
```

## Advanced Features

### State Stream Extensions

```dart
import 'package:state_stream/state_stream.dart';

final counter = MutableStateStream<int>(0);

// Wait for state change
final newValue = await counter.waitForUpdate();
print('New value: $newValue');

// Wait until condition is met
final evenValue = await counter.waitForWhere((value) => value % 2 == 0);
print('Even value: $evenValue');
```

### Lock State Monitoring

```dart
import 'package:state_stream/state_stream.dart';

final counter = MutableStateStream<int>(0);

// Check lock state
print('Locking: ${counter.isLocking}'); // false

// Check lock state asynchronously
final lockTask = counter.updateWithLock((state, emitter) async {
  // Lock state during update processing
  print('Lock state during update: ${counter.isLocking}'); // true
  
  await Future.delayed(Duration(milliseconds: 100));
  await emitter.emit(state + 1);
  return null;
});

// Lock state while updateWithLock is executing
print('External lock state: ${counter.isLocking}'); // true

// Wait for completion
await lockTask;

// Lock is released after completion
print('Lock state after completion: ${counter.isLocking}'); // false
```

### Resource Management

```dart
import 'package:state_stream/state_stream.dart';

// Specify callback on close
final counter = MutableStateStream<int>(
  0,
  onClose: (finalState) async {
    print('Final state: $finalState');
    // Cleanup processing
  },
);

// Check if state stream is valid and not locked
if (counter.isNotClosed && !counter.isLocking) {
  await counter.updateWithLock((state, emitter) async {
    await emitter.emit(state + 1);
    return null;
  });
}

// Release resources
await counter.close();

// Not in lock state after closing
print('Lock state after closing: ${counter.isLocking}'); // false
```

## Integration with Riverpod

Integration functionality with Riverpod is provided as a separate package:

```yaml
dependencies:
  state_stream: ^1.0.0
  state_stream_riverpod: ^1.0.0
```

For details, please refer to the [state_stream_riverpod](https://pub.dev/packages/state_stream_riverpod) package.

## License

MIT License
