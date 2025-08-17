import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_stream/src/dispatcher.dart';
import 'package:state_stream/src/impl/mutable_state_stream_impl.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';
import 'package:state_stream/src/state_stream.dart';

/// 更新可能な状態と通知を受け取るためのStreamを提供するインターフェース.
abstract class MutableStateStream<T> implements StateStream<T> {
  /// [MutableStateStream] を生成する.
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

  /// このStreamが破棄済みであるかどうかを取得する.
  /// trueを返却するとき、もうActionを行うことはできない.
  ///
  /// ただし、破棄済みであっても完全に処理が終了していない場合がある.
  bool get isClosed;

  /// このStreamがロックされている場合にtrueを返却する.
  /// trueの場合、何らかのタスクが実行中である.
  /// すでに [isClosed] である場合は、常にfalseを返却する.
  bool get isLocking;

  /// このStreamが有効である場合にtrueを返却する.
  bool get isNotClosed;

  /// 閉じる.
  Future close();

  /// 現在の状態をロックし、更新処理を行う.
  Future<R> updateWithLock<R>(
    Future<R> Function(
      T currentState,
      MutableStateStreamEmitter<T> emitter,
    )
    block, {
    UpdateWithLockOptions options = const UpdateWithLockOptions(),
  });

  /// ライフサイクルが終了するまで待機する.
  @internal
  Future waitForClosing();
}

/// [MutableStateStream.updateWithLock] に渡すオプション.
class UpdateWithLockOptions {
  const UpdateWithLockOptions();
}
