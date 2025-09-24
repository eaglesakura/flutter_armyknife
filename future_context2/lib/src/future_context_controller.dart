import 'package:flutter/foundation.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:rxdart/rxdart.dart';

/// FutureContextの全体制御用コントローラ.
abstract interface class FutureContextController {
  static FutureContextController? _instance;

  /// シングルトンインスタンスを返却する.
  static FutureContextController get instance {
    _instance ??= _FutureContextControllerImpl();
    return _instance!;
  }

  /// Logger
  set logger(Function(String) value);

  /// FutureContextの通知ストリーム.
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知を受けたFutureContextは、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  Stream<FutureContext> get notifyStream;

  /// Logger
  void log(String message);

  /// FutureContextの通知を発行する.
  void notify(FutureContext context);
}

class _FutureContextControllerImpl implements FutureContextController {
  final PublishSubject<FutureContext> _subject = PublishSubject();

  Function(String message) _logger = (String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(message);
  };

  @override
  set logger(Function(String message) value) {
    _logger = value;
  }

  /// FutureContextの通知ストリーム.
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知を受けたFutureContextは、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  @override
  Stream<FutureContext> get notifyStream => _subject.stream;

  @override
  void log(String message) {
    _logger(message);
  }

  /// FutureContextの通知を発行する.
  @override
  void notify(FutureContext context) {
    _subject.add(context);
  }
}
