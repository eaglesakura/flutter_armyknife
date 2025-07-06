import 'dart:async';

import 'package:async_notify2/async_notify2.dart';
import 'package:flutter/foundation.dart';
import 'package:future_context2/src/impl/legacy/future_context.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// port from https://github.com/vivitainc/flutter_future_context
@internal
extension StreamWithContext<T> on Stream<T> {
  static final _notify = PublishSubject<dynamic>();

  /// StreamとFutureContextを統合して新しいStreamを作成する.
  ///
  /// [context] がキャンセルされたタイミングで、このStreamもキャンセルされる.
  /// キャンセルされる場合、 [CancellationException] が投げられる点に注意すること.
  ///
  /// [receiveAllValues] がtrueのとき、 [context] がキャンセルされてもStreamをキャンセルせずに
  /// Streamが閉じるまで待つ.
  ///
  /// [withDebugLog] がtrueのとき、デバッグログを出力する.
  Stream<T> withContext(
    FutureContext context, {
    bool receiveAllValues = false,
    bool withDebugLog = kDebugMode,
  }) {
    final stackTrace = StackTrace.current;
    late final PublishSubject<T> subject;
    bool launched = false;

    void log(String message) {
      if (withDebugLog) {
        debugPrint(
          '${DateTime.now().toIso8601String()} [Stream<$T>.withContext] $message',
        );
      }
    }

    subject = PublishSubject<T>(
      onListen: () {
        if (launched) {
          return;
        }
        launched = true;
        unawaited(
          _proxy(
            context,
            receiveAllValues,
            subject,
            log,
          ),
        );
        unawaited(
          _cancellation(
            context,
            subject,
            stackTrace,
            log,
          ),
        );
      },
    );

    return subject.stream;
  }

  /// キャンセル対応を行う.
  /// キャンセルされた場合、[subject]にエラーを流して、[subject]をcloseする.
  Future _cancellation(
    FutureContext context,
    Subject<T> subject,
    StackTrace stackTrace,
    void Function(String message) log,
  ) async {
    final key = this;
    final stream = CombineLatestStream.combine2(
      context.isCanceledStream,
      _notify.where((event) => identical(event, key)),
      (a, b) => a,
    );
    try {
      await for (final isCanceled in stream) {
        if (subject.isClosed) {
          return;
        } else if (!isCanceled) {
          continue;
        } else if (!subject.isClosed) {
          subject.addError(
            CancellationException(
              '[Stream<$T>.withContext] ${context.toString()} is canceled',
            ),
            stackTrace,
          );
          unawaited(subject.close());
        }
        return;
      }
    } finally {
      log('cancellation close');
    }
  }

  /// データの受領と再送を行う.
  /// Stream内部で例外が発生する場合があるため、データはすべて受領する.
  Future _proxy(
    FutureContext context,
    bool receiveAllValues,
    Subject<T> subject,
    void Function(String message) log,
  ) async {
    final key = this;
    try {
      await for (final v in this) {
        _notify.add(key);
        if (subject.isClosed) {
          if (receiveAllValues) {
            continue;
          }
          return;
        } else {
          subject.add(v);
        }
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stackTrace) {
      if (!subject.isClosed) {
        subject.addError(e, stackTrace);
      } else {
        log('${context.toString()} is canceled, drop error: $e\n$stackTrace');
      }
    } finally {
      log('proxy close');
      _notify.add(key);
      if (!subject.isClosed) {
        unawaited(subject.close());
      }
    }
  }
}
