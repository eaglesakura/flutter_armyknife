import 'dart:async';

import 'package:async_notify2/src/cancellation_exception.dart';
import 'package:rxdart/rxdart.dart';

var _durationKey = 0;

/// Objectのwait/notifyパターンを提供する.
///
/// キャンセル可能な待ち合わせ及び [Notify.delay] のスリープ処理を提供する.
/// キャンセルが発生した場合、 [CancellationException] を投げる.
///
/// 利用終了後、必ず [dispose] でメモリを解放する.
class Notify {
  final _subject = PublishSubject<dynamic>();

  /// Notify.dispose()が呼び出されていない状態であればtrueを返却する.
  bool get isClosed => _subject.isClosed;

  /// 指定時間処理を停止する.
  /// dispose()が発行された場合、その時点で [CancellationException] を発行して呼び出し元へ戻る.
  Future delay(final Duration duration) async {
    _assertNotClosed();
    final key = _durationKey++;
    Timer(duration, () {
      if (!_subject.isClosed) {
        _subject.add(key);
      }
    });
    await for (final value in _subject.stream) {
      _assertNotDisposed(await value);
      if (value == key) {
        // OK!
        return;
      }
    }
    _assertNotClosed();
  }

  /// Notifyを終了する.
  /// 現在待ち合わせているリソースはすべてCancelが発行される.
  Future dispose() {
    if (isClosed) {
      return Future<void>.value(null);
    }
    _subject.add(_NotifyMessage.dispose);
    return _subject.close();
  }

  /// wait()しているオブジェクトの動作を再開する
  void notify() {
    if (isClosed) {
      return;
    }
    _subject.add(_NotifyMessage.notify);
  }

  /// 何らかのNotify()が発行されるまで待ち合わせる.
  ///
  /// [message] を指定すると、例外設定に利用される
  Future wait({String message = 'Notify.dispose() called'}) async {
    _assertNotClosed(message: message);
    while (!isClosed) {
      // ignore: implicit_dynamic_variable
      final value = await _subject.first;
      _assertNotDisposed(value, message: message);
      if (value == _NotifyMessage.notify) {
        return;
      }
    }
    _assertNotClosed(message: message);
  }

  void _assertNotClosed({
    String message = 'Notify.dispose() called',
  }) {
    if (_subject.isClosed) {
      throw CancellationException(message);
    }
  }

  void _assertNotDisposed(
    dynamic value, {
    String message = 'Notify.dispose() called',
  }) {
    if (value == _NotifyMessage.dispose || _subject.isClosed) {
      throw CancellationException(message);
    }
  }
}

enum _NotifyMessage {
  notify,
  dispose,
}
