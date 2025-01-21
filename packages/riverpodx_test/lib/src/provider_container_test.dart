import 'package:flutter_test/flutter_test.dart';
import 'package:riverpodx/riverpodx.dart';

final class ProviderContainerTest {
  const ProviderContainerTest._();

  static ProviderContainer create({
    List<Override> overrides = const [],
  }) {
    final result = ProviderContainer(
      overrides: {
        ...overrides,
        ...ProviderContainerAsyncHelper.inject(),
      }.toList(),
    );
    addTearDown(() async {
      await result.disposeAsync();
    });
    return result;
  }
}

extension ProviderContainerTestExtensions on ProviderContainer {
  /// インスタンスを取得する.
  T testGet<T>(ProviderListenable<T> provider) {
    if (provider is AutoDisposeProvider<T>) {
      listen(provider, (prev, next) {});
      return read(provider);
    } else {
      return read(provider);
    }
  }

  /// インスタンスを取得し、準備完了状態にする.
  Future<T> testReady<T>(ProviderListenable<T> provider) async {
    await _readyDependencies(provider);
    return testGet(provider);
  }

  List<ProviderListenableOrFamily> _getDependencies(
      ProviderListenable provider) {
    if (provider is AutoDisposeProvider) {
      return provider.dependencies?.toList() ?? [];
    } else if (provider is Provider) {
      return provider.dependencies?.toList() ?? [];
    }

    return const [];
  }

  /// 依存グラフを構築し、全てのProviderを準備完了状態にする.
  Future _readyDependencies(ProviderListenable provider) async {
    final dependencies = _getDependencies(provider);
    for (final p in dependencies) {
      if (p is ProviderListenable) {
        await _readyDependencies(p);
      }
    }
    // オブジェクトを取得
    testGet(provider);
    await waitInitializeTasks();
  }
}
