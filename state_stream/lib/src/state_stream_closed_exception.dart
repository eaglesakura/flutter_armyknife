import 'package:async_notify2/async_notify2.dart';
import 'package:state_stream/state_stream.dart';

/// [StateStream]がすでにCloseされている場合に投げられる例外.
class StateStreamClosedException implements CancellationException {
  @override
  final String message;

  StateStreamClosedException(this.message);

  @override
  String toString() {
    return 'StateStreamClosedException(message: $message)';
  }
}
