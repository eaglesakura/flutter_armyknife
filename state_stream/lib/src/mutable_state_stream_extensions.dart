import 'dart:async';

import 'package:future_context2/future_context2.dart';
import 'package:state_stream/state_stream.dart';

/// [MutableStateStream] のライフサイクル連携ヘルパー.
extension MutableStateStreamExtensions<T> on MutableStateStream<T> {
  /// 閉じられたときに呼ばれるコールバックを登録する.
  ///
  /// [callback] は [MutableStateStream.waitForClosing] 完了後に1回呼ばれる.
  ///
  /// Example:
  /// ```dart
  /// stream.onClose((s) => print('closed'));
  /// ```
  void onClose(Function(MutableStateStream<T> stream) callback) {
    waitForClosing().then((_) {
      callback(this);
    });
  }

  /// Streamの内容が [test] を満たさなかった場合に
  /// [onClose] を実行する.
  ///
  /// [test] がtrueの間は待機し、falseになった時点、またはStream終了時に [onClose] を呼ぶ.
  ///
  /// Example:
  /// ```dart
  /// stream.onCloseWhere((s) => s > 0, () => print('non-positive'));
  /// ```
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

  /// 閉じられたときに [context] を閉じる.
  ///
  /// Example:
  /// ```dart
  /// stream.withFutureContext(context);
  /// ```
  void withFutureContext(FutureContext context) {
    onClose((_) => context.close());
  }

  /// 閉じられたときに [subscription] をキャンセルする.
  ///
  /// Example:
  /// ```dart
  /// stream.withSubscription(subscription);
  /// ```
  void withSubscription(StreamSubscription subscription) {
    onClose((_) => subscription.cancel());
  }
}
