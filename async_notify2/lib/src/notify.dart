import 'dart:async';

import 'package:async_notify2/src/cancellation_exception.dart';
import 'package:rxdart/rxdart.dart';

/// [Notify.delay] が発行する完了キーの連番カウンタ.
var _durationKey = 0;

/// Objectのwait/notifyパターンを提供する.
///
/// キャンセル可能な待ち合わせ及び [Notify.delay] のスリープ処理を提供する.
/// キャンセルが発生した場合、 [CancellationException] を投げる.
///
/// 利用終了後、必ず [dispose] でメモリを解放する.
class Notify {
  /// wait/notify/delayのイベントを配信する内部Subject.
  final _subject = PublishSubject<dynamic>();

  /// [dispose] が呼び出されていない状態であればtrueを返却する.
  bool get isClosed => _subject.isClosed;

  /// 指定時間処理を停止する.
  ///
  /// [duration] 経過後に復帰する.
  /// [dispose] が発行された場合、その時点で [CancellationException] を発行して呼び出し元へ戻る.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// await notify.delay(const Duration(milliseconds: 100));
  /// await notify.dispose();
  /// ```
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
  ///
  /// 現在待ち合わせているリソースはすべてCancelが発行される.
  /// 二重呼び出し時は何もしない.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// await notify.dispose();
  /// ```
  Future dispose() {
    if (isClosed) {
      return Future<void>.value(null);
    }
    _subject.add(_NotifyMessage.dispose);
    return _subject.close();
  }

  /// [wait]しているオブジェクトの動作を再開する.
  ///
  /// 既に閉じている場合は何もしない.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final waiting = notify.wait();
  /// notify.notify();
  /// await waiting;
  /// await notify.dispose();
  /// ```
  void notify() {
    if (isClosed) {
      return;
    }
    _subject.add(_NotifyMessage.notify);
  }

  /// 何らかの[notify]が発行されるまで待ち合わせる.
  ///
  /// [message]を指定すると、例外設定に利用される.
  /// [dispose]後、または待ち合わせ中に閉じられた場合は[CancellationException]を投げる.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final waiting = notify.wait(message: 'stopped');
  /// notify.notify();
  /// await waiting;
  /// await notify.dispose();
  /// ```
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

  /// 閉じ済みなら[CancellationException]を投げる.
  ///
  /// [message]は例外に載せる文言.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// await notify.dispose();
  /// // 以降の delay / wait は CancellationException になる
  /// ```
  void _assertNotClosed({
    String message = 'Notify.dispose() called',
  }) {
    if (_subject.isClosed) {
      throw CancellationException(message);
    }
  }

  /// disposeイベントまたは閉じ済みなら[CancellationException]を投げる.
  ///
  /// [value]が[_NotifyMessage.dispose]の場合もキャンセル扱いとする.
  /// [message]は例外に載せる文言.
  ///
  /// Example:
  /// ```dart
  /// final notify = Notify();
  /// final waiting = notify.wait();
  /// await notify.dispose();
  /// // waiting は CancellationException で完了する
  /// ```
  void _assertNotDisposed(
    dynamic value, {
    String message = 'Notify.dispose() called',
  }) {
    if (value == _NotifyMessage.dispose || _subject.isClosed) {
      throw CancellationException(message);
    }
  }
}

/// [Notify] 内部でSubjectへ流す制御メッセージ.
enum _NotifyMessage {
  /// [Notify.notify] に対応する再開シグナル.
  notify,

  /// [Notify.dispose] に対応する終了シグナル.
  dispose,
}
