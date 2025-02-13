import 'package:synchronized/synchronized.dart';

/// 順番を保ったキューイングシステムを提供する.
abstract class TaskQueue {
  /// タスクキューを生成する.
  factory TaskQueue() => _TaskQueue();

  /// タスクが空かどうかを返す.
  bool get isEmpty;

  /// タスクが存在するかどうかを返す.
  bool get isNotEmpty;

  /// タスクを末尾に追加する.
  ///
  /// 追加されたタスクが完了するまで次のタスクが実行されない.
  Future<T> queue<T>(Future<T> Function() block);
}

/// [TaskQueue] の実装.
class _TaskQueue implements TaskQueue {
  final _lock = Lock();

  /// 次に発行されるタスク番号.
  var _taskId = 0;

  /// 現在実行権があるタスク番号
  var _currentId = 0;

  @override
  bool get isEmpty => _taskId == _currentId;

  @override
  bool get isNotEmpty => !isEmpty;

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

  /// 次のタスクを実行する.
  int _nextId() {
    final id = _taskId;
    return _taskId++;
  }
}
