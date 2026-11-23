import 'package:synchronized/synchronized.dart';

/// 順番を保ったキューイングシステムを提供する.
///
/// [queue] で追加した非同期処理は、先入れ順に1つずつ実行される.
/// 並列実行は行わず、前タスク完了後に次タスクへ進む.
abstract class TaskQueue {
  /// タスクキューを生成する.
  ///
  /// Example:
  /// ```dart
  /// final queue = TaskQueue();
  /// await queue.queue(() async => 1);
  /// ```
  factory TaskQueue() => _TaskQueue();

  /// タスクが空かどうかを返す.
  ///
  /// 待機中・実行中のタスクが無いとき `true`.
  bool get isEmpty;

  /// タスクが存在するかどうかを返す.
  ///
  /// 待機中または実行中のタスクがあるとき `true`.
  bool get isNotEmpty;

  /// すべてのタスクが完了するのを待つ.
  ///
  /// キューが空になるまで空タスクを積んで待ち合わせる.
  ///
  /// Example:
  /// ```dart
  /// final queue = TaskQueue();
  /// unawaited(queue.queue(() async {}));
  /// await queue.join();
  /// ```
  Future join();

  /// タスクを末尾に追加する.
  ///
  /// 追加されたタスクが完了するまで次のタスクが実行されない.
  /// [block] の戻り値がそのまま完了値になる.
  ///
  /// Example:
  /// ```dart
  /// final queue = TaskQueue();
  /// final value = await queue.queue(() async => 42);
  /// ```
  Future<T> queue<T>(Future<T> Function() block);
}

/// [TaskQueue] の実装.
///
/// 連番の実行権と [Lock] で直列実行を保証する.
class _TaskQueue implements TaskQueue {
  /// 実行権の取得に使うロック.
  final _lock = Lock();

  /// 次に発行されるタスク番号.
  var _taskId = 0;

  /// 現在実行権があるタスク番号.
  var _currentId = 0;

  /// 待機中・実行中のタスクが無いとき `true`.
  @override
  bool get isEmpty => _taskId == _currentId;

  /// 待機中または実行中のタスクがあるとき `true`.
  @override
  bool get isNotEmpty => !isEmpty;

  /// すべてのタスクが完了するのを待つ.
  ///
  /// タスクリストが空になるまで、タスクキューを空実行する.
  ///
  /// Example:
  /// ```dart
  /// final queue = _TaskQueue();
  /// await queue.join();
  /// ```
  @override
  Future join() async {
    // タスクリストが空になるまで、タスクキューを空実行する.
    while (isNotEmpty) {
      await queue(() async {});
    }
  }

  /// タスクを末尾に追加して直列実行する.
  ///
  /// [block] は実行権取得後に一度だけ呼ばれる.
  ///
  /// Example:
  /// ```dart
  /// final queue = _TaskQueue();
  /// final value = await queue.queue(() async => 'ok');
  /// ```
  @override
  Future<T> queue<T>(Future<T> Function() block) async {
    final id = _nextId();
    var done = false;
    late T result;

    while (!done) {
      await _lock.synchronized(() async {
        // 実行権がある場合、実行する.
        if (_currentId == id) {
          try {
            result = await block();
          } finally {
            // 次のタスクに移行する.
            done = true;
            _currentId++;
          }
        }
      });
    }
    return result;
  }

  /// 次のタスク番号を採番して返す.
  ///
  /// 副作用として [_taskId] を1つ進める.
  ///
  /// Example:
  /// ```dart
  /// final id = _TaskQueue()._nextId();
  /// ```
  int _nextId() {
    final id = _taskId;
    ++_taskId;
    return id;
  }
}
