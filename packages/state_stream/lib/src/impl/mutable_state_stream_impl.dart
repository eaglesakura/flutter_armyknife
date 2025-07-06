import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:armyknife_task_queue/armyknife_task_queue.dart';
import 'package:async_notify2/async_notify2.dart';
import 'package:meta/meta.dart';
import 'package:runtime_assert/runtime_assert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_stream/src/dispatcher.dart';
import 'package:state_stream/src/impl/mutable_state_stream_state.dart';
import 'package:state_stream/src/mutable_state_stream.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';

@internal
class MutableStateStreamImpl<T> implements MutableStateStream<T> {
  final BehaviorSubject<MutableStateStreamState<T>> _subject;

  /// Dispatcherを利用する場合は、Dispatcherを指定する
  final Dispatcher<T> _dispatcher;

  final _taskQueue = TaskQueue();

  MutableStateStreamImpl({
    required T initial,
    required Future<void> Function(T state) onClose,
    required Dispatcher<T>? dispatcher,
  }) : _subject = BehaviorSubject.seeded(
         MutableStateStreamState(
           state: initial,
           lifecycle: MutableStateStreamLifecycle.alive,
           onClose: onClose,
         ),
       ),
       _dispatcher = dispatcher ?? Dispatcher<T>();

  @override
  bool get isClosed =>
      _subject.value.lifecycle != MutableStateStreamLifecycle.alive;

  @override
  bool get isNotClosed => !isClosed;

  @override
  T get state => _subject.value.state;

  @override
  Stream<T> get stream => _subject.stream
      .map(
        (e) => e.state,
      )
      .distinct();

  @override
  Future close() async {
    check(
      _subject.value.lifecycle == MutableStateStreamLifecycle.alive,
      'StateStream<$T> is already closed.',
    );

    await _taskQueue.queue(() async {
      final value = _subject.value;
      check(
        value.lifecycle == MutableStateStreamLifecycle.alive,
        'StateStream<$T> is already closed.',
      );

      /// closingに変更
      _subject.value = value.copyWith(
        lifecycle: MutableStateStreamLifecycle.closing,
      );
      await nop();

      /// ステートを閉じる
      await value.onClose(value.state);

      // close状態に変更
      _subject.value = value.copyWith(
        lifecycle: MutableStateStreamLifecycle.closing,
      );
      await nop();
    });

    await _subject.close();
  }

  @override
  Future<R> updateWithLock<R>(
    Future<R> Function(
      T currentState,
      MutableStateStreamEmitter<T> emitter,
    )
    block, {
    UpdateWithLockOptions options = const UpdateWithLockOptions(),
  }) {
    return _taskQueue.queue(() async {
      // 実行権を得た
      if (isClosed) {
        throw CancellationException('StateStream<$T> is already closed.');
      }

      final emitter = _MutableStateStreamEmitterImpl(_subject);
      try {
        return await _dispatcher.dispatch(
          this,
          _subject.value.state,
          emitter,
          block,
        );
      } finally {
        emitter.close();
      }
    });
  }

  @override
  Future waitForClosing() {
    if (isClosed) {
      return Future.value();
    }

    return _subject
        .map((e) => e.lifecycle)
        .where((e) => e != MutableStateStreamLifecycle.alive)
        .first;
  }
}

class _MutableStateStreamEmitterImpl<T>
    implements MutableStateStreamEmitter<T> {
  final BehaviorSubject<MutableStateStreamState<T>> _subject;

  var _closed = false;

  _MutableStateStreamEmitterImpl(this._subject);

  void close() {
    _closed = true;
  }

  @override
  Future<T> emit(T state) async {
    _assertAlive();

    final value = _subject.value;
    _subject.value = value.copyWith(
      state: state,
    );
    await nop();
    return state;
  }

  /// Emitterが利用可能な状態であることを確認する
  void _assertAlive() {
    check(!_closed, 'StateStream<$T> is already closed.');

    final value = _subject.value;
    if (value.lifecycle != MutableStateStreamLifecycle.alive) {
      throw CancellationException('StateStream<$T> is already closed.');
    }
  }
}
