import 'dart:async';

import 'package:future_contextx/future_contextx.dart';
import 'package:redux_stream2/redux_stream2.dart' as rs2;
import 'package:redux_streamx/src/redux_store.dart';
import 'package:redux_streamx/src/redux_store_lock.dart';
import 'package:runtime_assert/runtime_assert.dart';

/// Redux Storeの最後の状態を破棄するための関数.
@Deprecated('Use state_stream package')
typedef StateDisposer<T extends ReduxState> = rs2.ReduxStateDispose<T>;

/// 変更可能なReduxにおけるStoreオブジェクト.
///
/// [rs2.ReduxStore]をラップして、プロジェクトに最適化している.
@Deprecated('Use state_stream package')
class MutableReduxStore<T extends ReduxState> implements ReduxStore<T> {
  /// 内部実装
  final rs2.ReduxStore<T> _impl;

  /// このStoreのコンテキスト.
  /// [close]を呼び出すことで、このコンテキストを閉じることができる.
  final FutureContext context = FutureContext(tag: 'Store<$T>');

  /// 初期状態を指定してStoreを生成する.
  ///
  /// [onDispose] を指定することで、最後のStateの破棄処理を明示することができる.
  factory MutableReduxStore(
    T initial, {
    StateDisposer<T>? onDispose,
  }) {
    return MutableReduxStore._(
      rs2.ReduxStore(
        initial: initial,
        stateDispose: onDispose,
      ),
    );
  }

  MutableReduxStore._(this._impl);

  /// このStoreが破棄済みであるかどうかを取得する.
  /// trueを返却するとき、もうActionを行うことはできない.
  ///
  /// ただし、破棄済みであっても完全に処理が終了していない場合がある.
  @override
  bool get isDisposed => _impl.isDisposed;

  /// このStoreが有効である場合にtrueを返却する.
  @override
  bool get isNotDisposed => _impl.isNotDisposed;

  @override
  T get state => _impl.state;

  @override
  Future<T> get stateAsync => _stateAsyncImpl();

  @override
  Stream<T> get stream => _impl.stream;

  @override
  Future close() async {
    await context.close();
    await _impl.dispose();
  }

  /// 状態をロックする.
  ///
  /// ロックされた状態は、[ReduxStoreLock.unlock]を呼び出すことで解除できる.
  /// unlock()を呼び忘れた場合、デッドロックが発生する恐れがあるため扱いに注意すること.
  Future<ReduxStoreLock<T>> lock() async {
    if (isDisposed) {
      throw IllegalStateException('MutableReduxStore<$T> is already disposed.');
    }

    final unlock = Completer<T>();
    final initial = Completer<T>();
    unawaited(update((state) async* {
      initial.complete(state);
      final newState = await unlock.future;
      if (newState != state) {
        yield newState;
      }
    }));
    final state = await initial.future;
    final lock = ReduxStoreLockImpl<T>(state, unlock);
    return lock;
  }

  /// 更新関数を通して状態を更新する.
  Future<T> update(
    Stream<T> Function(T state) modifier, {
    bool skipIfDisposed = false,
  }) async {
    if (skipIfDisposed && isDisposed) {
      return _impl.state;
    }
    return _impl.dispatchAndResultBy(modifier);
  }

  /// 状態をロックして、更新関数を実行する.
  Future<R> withLock<R>(Future<R> Function(T state) block) async {
    final tryLock = await lock();
    try {
      return await block(tryLock.state);
    } finally {
      await tryLock.unlock();
    }
  }

  /// 現在積まれている更新関数をすべて完了させ、最後のステートを取得する.
  Future<T> _stateAsyncImpl() async {
    if (!_impl.hasActions()) {
      return state;
    }

    final completer = Completer<T>();
    unawaited(update((state) async* {
      completer.complete(state);
    }));
    return completer.future;
  }
}
