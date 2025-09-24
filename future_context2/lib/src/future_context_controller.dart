import 'package:flutter/foundation.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:rxdart/rxdart.dart';

part 'future_context_controller.impl.dart';

/// English: Overall control controller for FutureContext.
/// 日本語: FutureContextの全体制御用コントローラ.
abstract interface class FutureContextController {
  static FutureContextController? _instance;

  /// English: Returns the singleton instance.
  /// 日本語: シングルトンインスタンスを返却する.
  static FutureContextController get instance {
    _instance ??= _FutureContextControllerImpl();
    return _instance!;
  }

  /// English: Logger setter.
  /// 日本語: Loggerの設定.
  set logger(Function(String) value);

  /// English: Notification stream for FutureContext.
  /// Used when issuing any update notifications.
  ///
  /// FutureContext that receives notifications checks all Contexts including Groups
  /// and performs controls such as cancellation.
  ///
  /// 日本語: FutureContextの通知ストリーム.
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知を受けたFutureContextは、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  Stream<FutureContext> get notifyStream;

  /// English: Logger method.
  /// 日本語: ログ出力メソッド.
  void log(String message);

  /// English: Issues a notification for FutureContext.
  /// 日本語: FutureContextの通知を発行する.
  void notify(FutureContext context);
}
