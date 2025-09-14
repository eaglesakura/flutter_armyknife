# riverpod_container_async

A library that supports asynchronous initialization and disposal processing for Riverpod's ProviderContainer.
It enables safe execution of asynchronous initialization task management within Providers and asynchronous processing during ProviderContainer disposal.

## Features

- **Asynchronous Initialization Support**: Register asynchronous tasks during Provider initialization and wait for completion
- **Asynchronous Disposal Processing**: Safely execute asynchronous processing when ProviderContainer is disposed
- **Task Queue Management**: Execute initialization and disposal tasks sequentially and guarantee completion

## Getting started

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  riverpod_container_async: ^2.0.0
```

## Usage

```dart
import 'lib/riverpod_container_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create ProviderContainer with asynchronous initialization and disposal support
final container = ProviderContainer(
  overrides: [
    ...ProviderContainerAsyncHelper.inject(),
    // Other overrides
  ],
);

// Perform asynchronous initialization within Provider
final myServiceProvider = Provider((ref) {
  final service = MyService();

  // Register asynchronous initialization task
  ref.registerInitializeTasks(service.initialize());

  // Register asynchronous disposal processing
  ref.onDisposeAsync(() async {
    await service.dispose();
  });

  return service;
});

// Usage example
void main() async {
  final container = ProviderContainer(
    overrides: ProviderContainerAsyncHelper.inject(),
  );

  // Wait for all initialization tasks to complete
  await container.waitInitializeTasks();

  // Run the application
  runApp(MyApp());

  // Execute asynchronous disposal on termination
  await container.disposeAsync();
}
```

## Additional information

This package was created to safely execute asynchronous processing in Riverpod's ProviderContainer.
Bug reports and feature requests are accepted at [GitHub](https://github.com/eaglesakura/flutter_armyknife).
