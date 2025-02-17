import 'package:state_stream/src/mutable_state_stream.dart';

/// [MutableStateStream] の状態更新インターフェース.
///
/// [MutableStateStream.updateWithLock] のブロック内でコールされ、
/// ブロック内でのみ有効である.
/// [MutableStateStreamEmitter] が有効である間は、 [MutableStateStream] の有効性も保証される.
abstract class MutableStateStreamEmitter<T> {
  /// 状態を更新する.
  Future<T> emit(T state);
}
