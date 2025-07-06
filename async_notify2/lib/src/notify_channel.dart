import 'dart:collection';

import 'package:async_notify2/src/cancellation_exception.dart';
import 'package:async_notify2/src/notify.dart';

/// Notifyオブジェクトを共有したChannel制御.
///
/// コンストラクタに指定した [Notify] がキャンセルされると、自動的にこのChannelも制御をキャンセル扱いとする.
/// このクラスはNotifyの操作を行わないため、必要に応じて利用者が [Notify.dispose] をコールする.
class NotifyChannel<T> {
  final Notify _notify;

  final _queue = Queue<T>();

  NotifyChannel(Notify notify) : _notify = notify;

  bool get isClosed => _notify.isClosed;

  bool get isEmpty => _queue.isEmpty;

  bool get isNotEmpty => _queue.isNotEmpty;

  /// 受信待ちオブジェクト数.
  int get pendingItemCount => _queue.length;

  /// [NotifyChannel.send] が発行されるまで、受信まちを行う.
  /// コンストラクタに指定した [Notify] disposeされたとき、このメソッドは [CancellationException] を投げて終了する.
  Future<T> receive({
    String message = 'Channel is closed.',
  }) async {
    while (!_notify.isClosed) {
      if (_queue.isNotEmpty) {
        return _queue.removeFirst();
      }
      await _notify.wait(message: message);
    }

    throw CancellationException(message);
  }

  /// このChannelへ値を送信する.
  void send(
    T value, {
    String message = 'Channel is closed.',
  }) {
    if (_notify.isClosed) {
      throw CancellationException(message);
    }
    _queue.add(value);
    _notify.notify();
  }
}
