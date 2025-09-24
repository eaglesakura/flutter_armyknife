import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_context_request.freezed.dart';

/// English: Request parameters for FutureContext.
/// 日本語: FutureContextのリクエストパラメータ.
@freezed
sealed class FutureContextRequest with _$FutureContextRequest {
  const factory FutureContextRequest({
    /// English: Specifies the amount of stack to return when debugging.
    /// 日本語: デバッグ時に返すスタックの量を指定します。
    @Default(0) int debugCallStackLevel,
  }) = _FutureContextRequest;
}
