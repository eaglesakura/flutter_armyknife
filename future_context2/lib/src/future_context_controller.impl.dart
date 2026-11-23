part of 'future_context_controller.dart';

/// FutureContextControllerの既定実装.
///
/// プロセス全体で共有する通知Subjectとログ関数を保持する.
class _FutureContextControllerImpl implements FutureContextController {
  /// 通知配信用Subject.
  final PublishSubject<FutureContext> _subject = PublishSubject();

  /// 既定のログ出力関数.
  ///
  /// デバッグモード以外では何も出力しない.
  Function(String message) _logger = (String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(message);
  };

  /// Loggerを差し替える.
  ///
  /// [value] が以降の [log] で使われる.
  ///
  /// Example:
  /// ```dart
  /// FutureContextController.instance.logger = print;
  /// ```
  @override
  set logger(Function(String message) value) {
    _logger = value;
  }

  /// FutureContextの通知ストリーム.
  ///
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知受信後、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  @override
  Stream<FutureContext> get notifyStream => _subject.stream;

  /// ログを出力する.
  ///
  /// [message] は現在の [_logger] に渡される.
  ///
  /// Example:
  /// ```dart
  /// FutureContextController.instance.log('done');
  /// ```
  @override
  void log(String message) {
    _logger(message);
  }

  /// FutureContextの通知を発行する.
  ///
  /// [context] を [_subject] へ流し、購読中のContextへ状態再評価を促す.
  ///
  /// Example:
  /// ```dart
  /// FutureContextController.instance.notify(context);
  /// ```
  @override
  void notify(FutureContext context) {
    _subject.add(context);
  }
}
