import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:future_context2/src/future_context_request.dart';
import 'package:future_context2/src/impl/legacy/future_context.dart' as legacy;
import 'package:meta/meta.dart';

/// [legacy.FutureContext] の機能をラップしたデフォルト実装.
@internal
class FutureContextProxy implements FutureContext {
  final legacy.FutureContext _impl;

  FutureContextProxy(this._impl);

  @override
  bool get isActive => _impl.isActive;

  @override
  bool get isCanceled => _impl.isCanceled;

  @override
  Stream<bool> get isCanceledStream => _impl.isCanceledStream;

  @override
  Future close() => _impl.close();

  @override
  Future delayed(Duration duration) => _impl.delayed(duration);

  @override
  T? queryInterface<T>() {
    if (typeEquals<T, legacy.FutureContext>()) {
      return _impl as T;
    } else if (typeEquals<T, FutureContextProxy>()) {
      return this as T;
    }
    return null;
  }

  @override
  Future<T2> suspend<T2>(FutureSuspendBlock<T2> block) =>
      _impl.suspend((context) {
        return block(FutureContextProxy(context));
      });

  @override
  Future<T2> withTimeout<T2>(
    Duration timeout,
    FutureSuspendBlock<T2> block, {
    FutureContextRequest request = const FutureContextRequest(),
  }) {
    return _impl.withTimeout(
      timeout,
      (context) => block(FutureContextProxy(context)),
      debugCallStackLevel: request.debugCallStackLevel,
    );
  }
}
