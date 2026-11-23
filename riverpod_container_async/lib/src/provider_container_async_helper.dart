import 'dart:async';

import 'package:armyknife_task_queue/armyknife_task_queue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart';

/// [Provider] のシャットダウン処理を行う関数.
///
/// 戻り値は `await` 可能な任意の値を想定する.
typedef ProviderAsyncDisposeFunction = dynamic Function();

/// [ProviderScope] の非同期処理をサポートするヘルパークラス.
///
/// [inject] で得た [Override] を [ProviderContainer] へ登録したうえで利用する.
/// 未登録のまま拡張メソッドを呼ぶと [UnimplementedError] になる.
///
/// e.g.
/// ProviderContainer(
///   overrides: [
///    ...ProviderContainerAsyncHelper.inject(),
///   ],
/// );
class ProviderContainerAsyncHelper {
  /// Helper本体を提供する内部Provider.
  ///
  /// [inject] 未適用時は生成時に [UnimplementedError] を投げる.
  static final _provider = Provider<ProviderContainerAsyncHelper>(
    (ref) => throw UnimplementedError('$ProviderContainerAsyncHelper'),
  );

  /// [inject] が返す固定Override一覧.
  static final _inject = [
    _provider.overrideWith((ref) {
      final helper = ProviderContainerAsyncHelper._();
      ref.keepAlive();
      return helper;
    }),
  ];

  /// 非同期実行中のタスク.
  ///
  /// 初期化・解放の完了待ちに使う.
  final _tasks = TaskQueue();

  /// 外部からの直接生成を禁止する.
  ///
  /// [inject] 経由でのみインスタンス化する.
  ProviderContainerAsyncHelper._();

  /// [ProviderContainer] に追加する [Override] を取得する.
  ///
  /// 返却リストを [ProviderContainer] のoverridesへ展開して登録する.
  ///
  /// Example:
  /// ```dart
  /// final container = ProviderContainer(
  ///   overrides: [
  ///     ...ProviderContainerAsyncHelper.inject(),
  ///   ],
  /// );
  /// ```
  static List<Override> inject() {
    return _inject;
  }
}

/// [ProviderContainer] 向けの非同期ライフサイクル拡張.
extension ProviderContainerAsyncExtensions on ProviderContainer {
  /// 非同期の開放関数を含めて解放を行う.
  ///
  /// 先に同期の [dispose] を実行し、登録済みの非同期解放が終わるまで待つ.
  /// [ProviderContainerAsyncHelper.inject] の登録が前提.
  ///
  /// Example:
  /// ```dart
  /// final container = ProviderContainer(
  ///   overrides: [...ProviderContainerAsyncHelper.inject()],
  /// );
  /// await container.disposeAsync();
  /// ```
  Future disposeAsync() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    dispose();

    // すべての開放関数が完了するのを待つ.
    await helper._tasks.join();
  }

  /// すべての初期化関数が完了するまで待つ.
  ///
  /// [RefAsyncExtensions.registerInitializeTasks] で積んだタスクの完了を待つ.
  /// [ProviderContainerAsyncHelper.inject] の登録が前提.
  ///
  /// Example:
  /// ```dart
  /// await container.waitInitializeTasks();
  /// ```
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._tasks.join();
  }
}

/// [Ref] 向けの非同期ライフサイクル拡張.
extension RefAsyncExtensions on Ref {
  /// 非同期の開放関数を登録する.
  ///
  /// [function] はProvider破棄時にキューへ積まれ、完了は [ProviderContainerAsyncExtensions.disposeAsync] で待つ.
  /// [ProviderContainerAsyncHelper.inject] の登録が前提.
  ///
  /// Example:
  /// ```dart
  /// ref.onDisposeAsync(() async {
  ///   await connection.close();
  /// });
  /// ```
  void onDisposeAsync(ProviderAsyncDisposeFunction function) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    onDispose(() {
      helper._tasks.queue(() async {
        await function();
      });
    });
  }

  /// 初期化関数を登録する.
  ///
  /// 初期化待ちを行うことができる.
  /// [task] はキューへ積まれ、完了は [waitInitializeTasks] で待つ.
  /// [ProviderContainerAsyncHelper.inject] の登録が前提.
  ///
  /// Example:
  /// ```dart
  /// ref.registerInitializeTasks(repository.warmUp());
  /// ```
  void registerInitializeTasks(Future task) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    unawaited(
      helper._tasks.queue(() async {
        await task;
      }),
    );
  }

  /// すべての初期化関数が完了するまで待つ.
  ///
  /// [registerInitializeTasks] で積んだタスクの完了を待つ.
  /// [ProviderContainerAsyncHelper.inject] の登録が前提.
  ///
  /// Example:
  /// ```dart
  /// await ref.waitInitializeTasks();
  /// ```
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._tasks.join();
  }
}
