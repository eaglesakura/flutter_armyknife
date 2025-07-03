import 'package:state_stream/src/mutable_state_stream.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';

/// 状態更新処理の実行本体.
///
/// 実行方法やキューイングの方法は実装に依存する.
/// また、 blockから発生した例外のハンドリング方法もDispatcherの裁量に任されている.
abstract class Dispatcher<T> {
  /// デフォルトのDispatcher生成ファクトリ.
  /// アプリシステム側でデフォルト挙動を変更したい場合に使用する.
  static Dispatcher<T> Function<T>() defaultDispatcherFactory =
      _defaultDispatcherFactory;

  /// デフォルト実装を生成する.
  factory Dispatcher() => _defaultDispatcherFactory();

  /// 状態更新処理を行う.
  Future<R> dispatch<R>(
    MutableStateStream<T> stream,
    T currentState,
    MutableStateStreamEmitter<T> emitter,
    Future<R> Function(T currentState, MutableStateStreamEmitter<T> emitter)
    block,
  );

  static Dispatcher<T> _defaultDispatcherFactory<T>() => _Dispatcher();
}

/// [Dispatcher]のデフォルト実装.
class _Dispatcher<T> implements Dispatcher<T> {
  @override
  Future<R> dispatch<R>(
    MutableStateStream<T> stream,
    T currentState,
    MutableStateStreamEmitter<T> emitter,
    Future<R> Function(T currentState, MutableStateStreamEmitter<T> emitter)
    block,
  ) {
    return block(currentState, emitter);
  }
}
