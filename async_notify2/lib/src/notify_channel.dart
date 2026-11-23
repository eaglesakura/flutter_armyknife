import 'dart:collection';

import 'package:async_notify2/src/cancellation_exception.dart';
import 'package:async_notify2/src/notify.dart';

/// Notifyオブジェクトを共有したChannel制御.
///
/// コンストラクタに指定した [Notify] がキャンセルされると、自動的にこのChannelも制御をキャンセル扱いとする.
/// Notifyの操作は行わないため、必要に応じて利用者が [Notify.dispose] をコールする.
class NotifyChannel<T> {
  /// キャンセルと起床に共有する [Notify].
  final Notify _notify;

  /// 未受信の送信値を保持するFIFOキュー.
  final _queue = Queue<T>();

  /// [notify] を共有するチャネルを作成する.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final channel = NotifyChannel<int>(notify);
  /// channel.send(1);
  /// final value = await channel.receive();
  /// await notify.dispose();
  /// ```
  NotifyChannel(Notify notify) : _notify = notify;

  /// 共有 [Notify] が閉じ済みならtrue.
  bool get isClosed => _notify.isClosed;

  /// 受信待ちキューが空ならtrue.
  bool get isEmpty => _queue.isEmpty;

  /// 受信待ちキューに要素があればtrue.
  bool get isNotEmpty => _queue.isNotEmpty;

  /// 受信待ちオブジェクト数.
  int get pendingItemCount => _queue.length;

  /// [NotifyChannel.send]が発行されるまで、受信まちを行う.
  ///
  /// コンストラクタに指定した[Notify]がdisposeされたとき、このメソッドは[CancellationException]を投げて終了する.
  /// [message]はキャンセル例外に載せる文言.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final channel = NotifyChannel<String>(notify);
  /// final receiving = channel.receive(message: 'closed');
  /// channel.send('ok');
  /// final value = await receiving;
  /// await notify.dispose();
  /// ```
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

  /// チャネルへ値を送信する.
  ///
  /// [value] をキュー末尾へ追加し、待機中の [receive] を起こす.
  /// 閉じ済みの場合は [CancellationException] を投げる.
  /// [message] は例外に載せる文言.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final channel = NotifyChannel<int>(notify);
  /// channel.send(42, message: 'closed');
  /// await notify.dispose();
  /// ```
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
