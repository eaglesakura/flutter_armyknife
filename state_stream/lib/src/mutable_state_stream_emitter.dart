import 'package:state_stream/src/mutable_state_stream.dart';

/// [MutableStateStream] の状態更新インターフェース.
///
/// [MutableStateStream.updateWithLock] のブロック内でコールされ、
/// ブロック内でのみ有効である.
/// [MutableStateStreamEmitter] が有効である間は、 [MutableStateStream] の有効性も保証される.
abstract class MutableStateStreamEmitter<T> {
  /// 状態を更新する.
  ///
  /// [state] を新しい現在値として通知する.
  /// ブロック終了後やStream破棄後に呼ぶと例外となる.
  ///
  /// Example:
  /// ```dart
  /// await stream.updateWithLock((current, emitter) async {
  ///   return emitter.emit(current + 1);
  /// });
  /// ```
  Future<T> emit(T state);
}
