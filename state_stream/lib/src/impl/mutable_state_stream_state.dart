import 'package:freezed_annotation/freezed_annotation.dart';

part 'mutable_state_stream_state.freezed.dart';

/// 現在のライフサイクル状態.
@internal
enum MutableStateStreamLifecycle {
  /// 更新・購読が可能な生存状態.
  alive,

  /// close実行中の遷移状態.
  closing,

  /// 完全に閉じた状態.
  closed,
}

/// MutableStateStream内部で保持する状態スナップショット.
///
/// 現在値とライフサイクル、およびクローズ時コールバックをまとめる.
@internal
@freezed
abstract class MutableStateStreamState<T> with _$MutableStateStreamState<T> {
  /// [state] / [lifecycle] / [onClose] を持つスナップショットを作成する.
  ///
  /// Example:
  /// ```dart
  /// final snapshot = MutableStateStreamState<int>(
  ///   state: 0,
  ///   onClose: (_) async {},
  /// );
  /// ```
  const factory MutableStateStreamState({
    /// ライフサイクル.
    @Default(MutableStateStreamLifecycle.alive)
    MutableStateStreamLifecycle lifecycle,

    /// 現在の値.
    required T state,

    /// 開放関数.
    required Future Function(T state) onClose,
  }) = _MutableStateStreamState;

  /// freezed用のプライベートコンストラクタ.
  ///
  /// Example:
  /// ```dart
  /// // 通常は MutableStateStreamState(...) ファクトリを使う.
  /// final snapshot = MutableStateStreamState<int>(
  ///   state: 0,
  ///   onClose: (_) async {},
  /// );
  /// ```
  const MutableStateStreamState._();
}
