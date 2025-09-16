# riverpod_container_async_test

A test library that assists in creating Unit Tests for code using `riverpod_container_async`.
It provides asynchronous disposal functionality for ProviderContainer, automatic dependency resolution, and provider management features for testing.

## Features

- **Test Extension Methods**: Provides test-specific extension methods for `ProviderContainer`
- **Initialization Task Waiting**: Automatically waits for `riverpod_container_async` initialization tasks and fully prepares providers before test execution
- **Automatic Dependency Resolution**: `testReady` recursively builds the provider dependency graph and prepares all dependent providers to a ready state
- **Easy Instance Retrieval**: `testGet` provides type-safe instance retrieval from providers

## Getting started

Add the following to dev_dependencies in your `pubspec.yaml`:

```yaml
dev_dependencies:
  riverpod_container_async_test: ^1.0.0
```

## Usage

Create a ProviderContainer for testing and test providers:

```dart
import 'package:riverpod_container_async_test/riverpod_container_async_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider tests', () {
    test('should create provider container with async disposal', () async {
      final container = // Create ProviderContainer

      // Get provider value
      final value = container.testGet(myProvider);
      expect(value, isNotNull);

      // disposeAsync() is automatically called at the end of the test
    });

    test('should ready provider with dependencies', () async {
      final container = // Create ProviderContainer

      // Resolve dependencies and prepare provider to ready state
      final service = await container.testReady(myServiceProvider);
      expect(service.isReady, isTrue);
    });
  });
}
```

## Additional information

This package was created to simplify Unit Test creation for applications using `riverpod_container_async`.
In particular, the asynchronous disposal functionality of ProviderContainer helps prevent resource leaks between tests.
Bug reports and feature requests are accepted at [GitHub](https://github.com/eaglesakura/flutter_armyknife).
