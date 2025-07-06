import 'dart:async';

import 'package:future_context2/future_context2.dart';
import 'package:state_stream/state_stream.dart';

extension MutableStateStreamExtensions<T> on MutableStateStream<T> {
  /// このStreamが閉じられたときに呼ばれるコールバックを登録する.
  void onClose(Function(MutableStateStream<T> stream) callback) {
    waitForClosing().then((_) {
      callback(this);
    });
  }

  /// Streamの内容が [test] を満たさなかった場合に
  /// [onClose] を実行する.
  void onCloseWhere(
    bool Function(T state) test,
    Function onClose,
  ) {
    unawaited(() async {
      try {
        await for (final _ in stream.where(test)) {
          // 満たしている間は何もしない.
        }

        // 満たさなくなった.
      } finally {
        onClose();
      }
    }());
  }

  /// このStreamが閉じられたときに [context] を閉じる.
  void withFutureContext(FutureContext context) {
    onClose((_) => context.close());
  }

  /// このStreamが閉じられたときに [subscription] をキャンセルする.
  void withSubscription(StreamSubscription subscription) {
    onClose((_) => subscription.cancel());
  }
}
