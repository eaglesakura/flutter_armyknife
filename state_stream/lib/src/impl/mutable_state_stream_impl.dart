import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:armyknife_task_queue/armyknife_task_queue.dart';
import 'package:meta/meta.dart';
import 'package:runtime_assert/runtime_assert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_stream/src/dispatcher.dart';
import 'package:state_stream/src/impl/mutable_state_stream_state.dart';
import 'package:state_stream/src/mutable_state_stream.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';
import 'package:state_stream/src/state_stream_closed_exception.dart';

/// [MutableStateStream] の標準実装.
///
/// [TaskQueue] で更新を直列化し、[Dispatcher] 経由でブロックを実行する.
@internal
class MutableStateStreamImpl<T> implements MutableStateStream<T> {
  /// ライフサイクル付き状態を保持する [BehaviorSubject].
  final BehaviorSubject<MutableStateStreamState<T>> _subject;

  /// Dispatcherを利用する場合は、Dispatcherを指定する.
  final Dispatcher<T> _dispatcher;

  /// 更新処理を直列化するタスクキュー.
  final _taskQueue = TaskQueue();

  /// [initial] を初期値とする実装を作成する.
  ///
  /// [onClose] は [close] 時に呼ばれる.
  /// [dispatcher] がnullのときはデフォルトの [Dispatcher] を使う.
  ///
  /// Example:
  /// ```dart
  /// // 通常は MutableStateStream(...) ファクトリ経由で生成する.
  /// final stream = MutableStateStream(0);
  /// ```
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

  /// 破棄済み（alive以外）であればtrue.
  @override
  bool get isClosed =>
      _subject.value.lifecycle != MutableStateStreamLifecycle.alive;

  /// タスクキューに未完了タスクがあればtrue.
  ///
  /// すでに [isClosed] の場合は常にfalse.
  @override
  bool get isLocking {
    // すでに閉じている場合は、ロック中ではない.
    if (isClosed) {
      return false;
    }

    // tqにタスクが残っている場合は、ロック中である.
    return _taskQueue.isNotEmpty;
  }

  /// 有効（未破棄）であればtrue.
  @override
  bool get isNotClosed => !isClosed;

  /// 現在の値.
  @override
  T get state => _subject.value.state;

  /// 現在値の変更を通知するStream.
  ///
  /// 連続同一値はdistinctで抑制する.
  @override
  Stream<T> get stream => _subject.stream
      .map(
        (e) => e.state,
      )
      .distinct();

  /// ライフサイクルを終了し、以降の更新を受け付けなくする.
  ///
  /// Example:
  /// ```dart
  /// final stream = MutableStateStream(0);
  /// await stream.close();
  /// ```
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

  /// 現在の状態をロックし、更新処理を行う.
  ///
  /// [block] には現在状態と [MutableStateStreamEmitter] が渡される.
  /// 破棄済みの場合は [StateStreamClosedException] を投げる.
  ///
  /// Example:
  /// ```dart
  /// await stream.updateWithLock((current, emitter) async {
  ///   await emitter.emit(current + 1);
  ///   return null;
  /// });
  /// ```
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
        throw StateStreamClosedException('StateStream<$T> is already closed.');
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

  /// ライフサイクルが終了するまで待機する.
  ///
  /// Example:
  /// ```dart
  /// await stream.waitForClosing();
  /// ```
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

/// updateWithLockブロック内でのみ有効な [MutableStateStreamEmitter] 実装.
class _MutableStateStreamEmitterImpl<T>
    implements MutableStateStreamEmitter<T> {
  /// 状態を保持する [BehaviorSubject].
  final BehaviorSubject<MutableStateStreamState<T>> _subject;

  /// Emitterが無効化済みかどうか.
  var _closed = false;

  /// [_subject] を操作するEmitterを作成する.
  ///
  /// Example:
  /// ```dart
  /// // MutableStateStream.updateWithLock 内でのみ生成・利用される.
  /// await stream.updateWithLock((current, emitter) async {
  ///   return emitter.emit(current);
  /// });
  /// ```
  _MutableStateStreamEmitterImpl(this._subject);

  /// Emitterを無効化し、以降の [emit] を拒否する.
  ///
  /// Example:
  /// ```dart
  /// // updateWithLock の finally で自動的に呼ばれる.
  /// await stream.updateWithLock((current, emitter) async => current);
  /// ```
  void close() {
    _closed = true;
  }

  /// 状態を更新する.
  ///
  /// [state] を新しい現在値として通知する.
  ///
  /// Example:
  /// ```dart
  /// await stream.updateWithLock((current, emitter) async {
  ///   return emitter.emit(current + 1);
  /// });
  /// ```
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

  /// Emitterが利用可能な状態であることを確認する.
  ///
  /// Example:
  /// ```dart
  /// // emit の先頭で内部的に呼ばれる.
  /// await stream.updateWithLock((current, emitter) async {
  ///   return emitter.emit(current);
  /// });
  /// ```
  void _assertAlive() {
    check(!_closed, 'StateStream<$T> is already closed.');

    final value = _subject.value;
    if (value.lifecycle != MutableStateStreamLifecycle.alive) {
      throw StateStreamClosedException('StateStream<$T> is already closed.');
    }
  }
}
