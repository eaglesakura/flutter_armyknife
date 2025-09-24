part of 'future_context_controller.dart';

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
