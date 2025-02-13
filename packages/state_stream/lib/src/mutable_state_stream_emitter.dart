import 'package:state_stream/src/mutable_state_stream.dart';

/// [MutableStateStream] の状態更新インターフェース.
abstract class MutableStateStreamEmitter<T> {
  /// 状態を更新する.
  Future<T> emit(T state);
}
