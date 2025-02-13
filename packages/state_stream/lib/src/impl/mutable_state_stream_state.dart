import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutable_state_stream_state.freezed.dart';

/// 現在のライフサイクル状態
@internal
enum MutableStateStreamLifecycle {
  alive,
  closing,
  closed,
}

@freezed
class MutableStateStreamState<T> with _$MutableStateStreamState<T> {
  const factory MutableStateStreamState({
    /// ライフサイクル.
    @Default(MutableStateStreamLifecycle.alive)
    MutableStateStreamLifecycle lifecycle,

    /// 現在の値
    required T state,

    /// 開放関数.
    required Future Function(T state) dispose,
  }) = _MutableStateStreamState;

  const MutableStateStreamState._();
}
