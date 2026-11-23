import 'package:flutter/foundation.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:rxdart/rxdart.dart';

part 'future_context_controller.impl.dart';

/// FutureContextの全体制御用コントローラ.
///
/// シングルトン経由で通知ストリームとログ出力を共有する.
abstract interface class FutureContextController {
  /// シングルトンの保持先.
  ///
  /// 初回 [instance] アクセス時に実装が生成される.
  static FutureContextController? _instance;

  /// シングルトンインスタンス.
  ///
  /// 未生成なら内部実装を生成して保持する.
  static FutureContextController get instance {
    _instance ??= _FutureContextControllerImpl();
    return _instance!;
  }

  /// Loggerの設定.
  ///
  /// [value] に渡した関数が以降の [log] 呼び出しで使われる.
  set logger(Function(String) value);

  /// FutureContextの通知ストリーム.
  ///
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知受信後、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  Stream<FutureContext> get notifyStream;

  /// ログを出力する.
  ///
  /// [message] は [logger] に渡される本文.
  ///
  /// Example:
  /// ```dart
  /// FutureContextController.instance.log('suspended');
  /// ```
  void log(String message);

  /// FutureContextの通知を発行する.
  ///
  /// [context] の状態変化を購読側へ伝える副作用がある.
  ///
  /// Example:
  /// ```dart
  /// FutureContextController.instance.notify(context);
  /// ```
  void notify(FutureContext context);
}
