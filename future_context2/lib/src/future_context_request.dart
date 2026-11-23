import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_context_request.freezed.dart';

/// FutureContextのリクエストパラメータ.
///
/// 生成時のデバッグ挙動などをまとめて渡す.
@freezed
sealed class FutureContextRequest with _$FutureContextRequest {
  /// [FutureContextRequest] を生成する.
  ///
  /// [debugCallStackLevel] はデバッグ時に返すスタックの量を指定する.
  /// 呼び出し階層が深いほど値を大きくし、自動生成タグの取得位置を調整する.
  ///
  /// Example:
  /// ```dart
  /// const request = FutureContextRequest(debugCallStackLevel: 1);
  /// final context = FutureContext(request: request);
  /// ```
  const factory FutureContextRequest({
    /// デバッグ時に返すスタックの量.
    ///
    /// 自動生成タグの StackTrace 取得位置をずらすために使う.
    @Default(0) int debugCallStackLevel,
  }) = _FutureContextRequest;
}
