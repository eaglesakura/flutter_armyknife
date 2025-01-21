import 'dart:async';

import 'package:meta/meta.dart';
import 'package:redux_streamx/src/redux_store.dart';
import 'package:runtime_assert/runtime_assert.dart';

/// [ReduxStore] がロックされ、ステートが普遍になったことを示す.
abstract class ReduxStoreLock<T extends ReduxState> {
  /// LockされたタイミングのState.
  T get state;

  /// ロック解除し、新しいStateを取得する.
  Future unlock([T? newState]);
}

@internal
class ReduxStoreLockImpl<T extends ReduxState> implements ReduxStoreLock<T> {
  @override
  final T state;

  final Completer<T> _unlockNotify;

  ReduxStoreLockImpl(this.state, this._unlockNotify);

  @override
  Future unlock([T? newState]) async {
    if (_unlockNotify.isCompleted) {
      throw IllegalStateException('Already unlocked.');
    }
    _unlockNotify.complete(newState ?? state);
  }
}
