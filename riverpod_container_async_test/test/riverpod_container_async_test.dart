import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_container_async/riverpod_container_async.dart';
import 'package:riverpod_container_async_test/riverpod_container_async_test.dart';

void main() {
  setUp(() async {
    _onDisposeAsync = false;
  });

  group('onDisposeAsync', () {
    test('provider', () async {
      final container = ProviderContainer(
        overrides: [
          ...ProviderContainerAsyncHelper.inject(),
        ],
      );

      await container.testReady(testProvider);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(_onDisposeAsync, isFalse);
      await container.disposeAsync();
      expect(_onDisposeAsync, isTrue);
    });

    test('keepAlive', () async {
      final container = ProviderContainer(
        overrides: [
          ...ProviderContainerAsyncHelper.inject(),
        ],
      );

      await container.testReady(testKeepProvider);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(_onDisposeAsync, isFalse);
      await container.disposeAsync();
      expect(_onDisposeAsync, isTrue);
    });

    test('autoDispose', () async {
      final container = ProviderContainer(
        overrides: [
          ...ProviderContainerAsyncHelper.inject(),
        ],
      );

      await container.testReady(testAutoDisposeProvider);
      await Future.delayed(const Duration(milliseconds: 200));

      expect(_onDisposeAsync, isFalse);
      await container.disposeAsync();
      expect(_onDisposeAsync, isTrue);
    });
  });
}

final testAutoDisposeProvider = Provider.autoDispose<bool>((ref) {
  ref.onDisposeAsync(() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _onDisposeAsync = true;
  });

  return true;
});

final testKeepProvider = Provider<bool>((ref) {
  ref.onDisposeAsync(() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _onDisposeAsync = true;
  });

  ref.keepAlive();
  return true;
});

final testProvider = Provider<bool>((ref) {
  ref.onDisposeAsync(() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _onDisposeAsync = true;
  });

  return true;
});

var _onDisposeAsync = true;
