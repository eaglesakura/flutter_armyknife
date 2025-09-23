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

  /// FutureContextの通知ストリーム.
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知を受けたFutureContextは、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  Stream<FutureContext> get notifyStream;

  /// FutureContextの通知を発行する.
  void notify(FutureContext context);
}

class _FutureContextControllerImpl implements FutureContextController {
  final PublishSubject<FutureContext> _subject = PublishSubject();

  /// FutureContextの通知ストリーム.
  /// 何かしらの更新通知を発行する場合に利用する.
  ///
  /// 通知を受けたFutureContextは、Groupを含めたすべてのContextをチェックし、キャンセルなどの制御を行う.
  @override
  Stream<FutureContext> get notifyStream => _subject.stream;

  /// FutureContextの通知を発行する.
  @override
  void notify(FutureContext context) {
    _subject.add(context);
  }
}
