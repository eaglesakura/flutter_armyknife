import 'dart:async';

import 'package:armyknife_task_queue/armyknife_task_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [Provider] のシャットダウン処理を行う関数.
typedef ProviderAsyncDisposeFunction = dynamic Function();

/// [ProviderScope] の非同期処理をサポートするヘルパークラス.
///
/// e.g.
/// ProviderContainer(
///   overrides: [
///    ...ProviderContainerAsyncHelper.inject(),
///   ],
/// );
class ProviderContainerAsyncHelper {
  static final _provider = Provider<ProviderContainerAsyncHelper>(
    (ref) => throw UnimplementedError('$ProviderContainerAsyncHelper'),
  );

  static final _inject = [
    _provider.overrideWith((ref) {
      final helper = ProviderContainerAsyncHelper._();
      ref.keepAlive();
      return helper;
    }),
  ];

  /// 非同期実行中のタスク.
  final _tasks = TaskQueue();

  ProviderContainerAsyncHelper._();

  /// [ProviderContainer] に追加する [Override] を取得する.
  static List<Override> inject() {
    return _inject;
  }
}

extension ProviderContainerAsyncExtensions on ProviderContainer {
  /// 非同期の開放関数を含めて解放を行う.
  Future disposeAsync() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    dispose();

    // すべての開放関数が完了するのを待つ.
    await helper._tasks.join();
  }

  /// すべての初期化関数が完了するまで待つ.
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._tasks.join();
  }
}

extension RefAsyncExtensions on Ref {
  /// 非同期の開放関数を登録する.
  void onDisposeAsync(ProviderAsyncDisposeFunction function) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    onDispose(() {
      helper._tasks.queue(() async {
        await function();
      });
    });
  }

  /// 初期化関数を登録する.
  /// 初期化待ちを行うことができる.
  void registerInitializeTasks(Future task) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    unawaited(
      helper._tasks.queue(() async {
        await task;
      }),
    );
  }

  /// すべての初期化関数が完了するまで待つ.
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._tasks.join();
  }
}
