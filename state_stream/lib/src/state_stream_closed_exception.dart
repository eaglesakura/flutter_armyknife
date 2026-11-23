import 'package:async_notify2/async_notify2.dart';
import 'package:state_stream/state_stream.dart';

/// [StateStream]がすでにCloseされている場合に投げられる例外.
///
/// [CancellationException] として扱われ、更新操作の打ち切りに使える.
class StateStreamClosedException implements CancellationException {
  /// 呼び出し元へ伝えるクローズ理由.
  @override
  final String message;

  /// [message] を保持する例外を作成する.
  ///
  /// Example:
  /// ```dart
  /// throw StateStreamClosedException('already closed');
  /// ```
  StateStreamClosedException(this.message);

  /// デバッグ向けの文字列表現を返す.
  ///
  /// Example:
  /// ```dart
  /// final text = StateStreamClosedException('closed').toString();
  /// ```
  @override
  String toString() {
    return 'StateStreamClosedException(message: $message)';
  }
}
