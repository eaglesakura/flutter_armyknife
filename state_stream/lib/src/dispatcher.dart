import 'package:state_stream/src/mutable_state_stream.dart';
import 'package:state_stream/src/mutable_state_stream_emitter.dart';

/// [Dispatcher]を生成するファクトリ関数の型定義.
typedef DispatcherFactory = Dispatcher<T> Function<T>();

/// 状態更新処理の実行本体.
///
/// 実行方法やキューイングの方法は実装に依存する.
/// また、blockから発生した例外のハンドリング方法もDispatcherの裁量に任されている.
abstract class Dispatcher<T> {
  /// デフォルトのDispatcher生成ファクトリ.
  ///
  /// アプリシステム側でデフォルト挙動を変更したい場合に使用する.
  static DispatcherFactory defaultDispatcherFactory = _defaultDispatcherFactory;

  /// デフォルト実装を生成する.
  ///
  /// Example:
  /// ```dart
  /// final dispatcher = Dispatcher<int>();
  /// ```
  factory Dispatcher() => _defaultDispatcherFactory();

  /// 状態更新処理を行う.
  ///
  /// [stream] は対象の [MutableStateStream].
  /// [currentState] はロック取得時点の状態.
  /// [emitter] はブロック内でのみ有効な更新口.
  /// [block] が実際の更新処理.
  ///
  /// Example:
  /// ```dart
  /// // MutableStateStream.updateWithLock 経由で呼び出される.
  /// await stream.updateWithLock((current, emitter) async {
  ///   return emitter.emit(current + 1);
  /// });
  /// ```
  Future<R> dispatch<R>(
    MutableStateStream<T> stream,
    T currentState,
    MutableStateStreamEmitter<T> emitter,
    Future<R> Function(T currentState, MutableStateStreamEmitter<T> emitter)
    block,
  );

  /// 既定の [Dispatcher] 実装を返す.
  static Dispatcher<T> _defaultDispatcherFactory<T>() => _Dispatcher();
}

/// [Dispatcher]のデフォルト実装.
///
/// 渡されたblockをそのまま呼び出す.
class _Dispatcher<T> implements Dispatcher<T> {
  /// [block] をそのまま実行する.
  ///
  /// Example:
  /// ```dart
  /// // Dispatcher() 経由で利用する.
  /// final dispatcher = Dispatcher<int>();
  /// ```
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
