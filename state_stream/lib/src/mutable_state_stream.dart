import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_stream/src/dispatcher.dart';
import 'package:state_stream/src/impl/mutable_state_stream_impl.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';
import 'package:state_stream/src/state_stream.dart';

/// 更新可能な状態と通知を受け取るためのStreamを提供するインターフェース.
abstract class MutableStateStream<T> implements StateStream<T> {
  /// [MutableStateStream] を生成する.
  ///
  /// [initial] は初期状態.
  /// [onClose] は [close] 時に呼ばれる後処理（省略時は何もしない）.
  /// [dispatcher] は更新ブロックの実行戦略（省略時はデフォルトの [Dispatcher]）.
  ///
  /// Example:
  /// ```dart
  /// final stream = MutableStateStream(0);
  /// await stream.updateWithLock((current, emitter) async {
  ///   await emitter.emit(current + 1);
  ///   return null;
  /// });
  /// await stream.close();
  /// ```
  factory MutableStateStream(
    T initial, {
    Future Function(T state)? onClose,
    Dispatcher<T>? dispatcher,
  }) {
    return MutableStateStreamImpl(
      initial: initial,
      onClose: onClose ?? (_) async {},
      dispatcher: dispatcher,
    );
  }

  /// 破棄済みであればtrue.
  ///
  /// trueを返却するとき、もうActionを行うことはできない.
  /// ただし、破棄済みであっても完全に処理が終了していない場合がある.
  bool get isClosed;

  /// ロック中（何らかのタスク実行中）であればtrue.
  ///
  /// すでに [isClosed] である場合は、常にfalseを返却する.
  bool get isLocking;

  /// 有効（未破棄）であればtrue.
  bool get isNotClosed;

  /// ライフサイクルを終了し、以降の更新を受け付けなくする.
  ///
  /// Example:
  /// ```dart
  /// final stream = MutableStateStream(0);
  /// await stream.close();
  /// ```
  Future close();

  /// 現在の状態をロックし、更新処理を行う.
  ///
  /// [block] には現在状態と [MutableStateStreamEmitter] が渡される.
  /// 同時実行はキューで直列化される.
  /// 破棄済みの場合は StateStreamClosedException を投げる.
  /// [options] は将来拡張用のオプション.
  ///
  /// Example:
  /// ```dart
  /// await stream.updateWithLock((current, emitter) async {
  ///   await emitter.emit(current + 1);
  ///   return null;
  /// });
  /// ```
  Future<R> updateWithLock<R>(
    Future<R> Function(
      T currentState,
      MutableStateStreamEmitter<T> emitter,
    )
    block, {
    UpdateWithLockOptions options = const UpdateWithLockOptions(),
  });

  /// ライフサイクルが終了するまで待機する.
  ///
  /// Example:
  /// ```dart
  /// await stream.waitForClosing();
  /// ```
  @internal
  Future waitForClosing();
}

/// [MutableStateStream.updateWithLock] に渡すオプション.
class UpdateWithLockOptions {
  /// 既定オプションを生成する.
  ///
  /// Example:
  /// ```dart
  /// await stream.updateWithLock(
  ///   (current, emitter) async => current,
  ///   options: const UpdateWithLockOptions(),
  /// );
  /// ```
  const UpdateWithLockOptions();
}
