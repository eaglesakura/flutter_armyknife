import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod_container_async/riverpod_container_async.dart';

/// [ProviderContainerAsyncHelper] を含んで初期化された [ProviderContainer] のUnit Testをサポートする.
///
/// 依存の初期待ちを行うことで、Unit Testを行いやすくする.
/// [ProviderContainerAsyncHelper.inject] の登録が前提.
extension ProviderContainerAsyncTestExtensions on ProviderContainer {
  /// インスタンスを取得する.
  ///
  /// [provider] を [listen] してから [read] し、破棄されにくい状態で値を返す.
  ///
  /// Example:
  /// ```dart
  /// final value = container.testGet(counterProvider);
  /// ```
  T testGet<T>(ProviderListenable<T> provider) {
    listen(provider, (prev, next) {});
    return read(provider);
  }

  /// インスタンスを取得し、準備完了状態にする.
  ///
  /// [ProviderContainerAsyncExtensions.waitInitializeTasks] に登録されたタスクが存在する場合、
  /// すべてのタスク完了待ちを行う.
  /// [provider] の依存グラフも再帰的に準備する.
  ///
  /// Example:
  /// ```dart
  /// final repo = await container.testReady(repositoryProvider);
  /// ```
  Future<T> testReady<T>(ProviderListenable<T> provider) async {
    await _readyDependencies(provider);
    return testGet(provider);
  }

  /// [provider] が宣言する依存一覧を取得する.
  ///
  /// [NotifierProvider] と [Provider] 以外は空リストを返す.
  List<ProviderListenableOrFamily> _getDependencies(
    ProviderListenable provider,
  ) {
    if (provider is NotifierProvider) {
      return provider.dependencies?.toList() ?? [];
    } else if (provider is Provider) {
      return provider.dependencies?.toList() ?? [];
    }

    return const [];
  }

  /// 依存グラフを構築し、全てのProviderを準備完了状態にする.
  ///
  /// [provider] の依存を先に準備し、自身を [testGet] したうえで初期化タスク完了を待つ.
  ///
  /// Example:
  /// ```dart
  /// await container._readyDependencies(repositoryProvider);
  /// ```
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
