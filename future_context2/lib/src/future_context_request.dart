import 'package:freezed_annotation/freezed_annotation.dart';

part 'future_context_request.freezed.dart';

/// FutureContextのリクエストパラメータ.
@freezed
sealed class FutureContextRequest with _$FutureContextRequest {
  const factory FutureContextRequest({
    /// デバッグ出力時のStackの戻る量を指定する.
    @Default(0) int debugCallStackLevel,
  }) = _FutureContextRequest;
}
