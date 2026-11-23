import 'package:state_stream/src/state_stream.dart';

/// mapperで変換した [StateStream] 実装.
///
/// 変換結果はdistinct相当で連続同一値を抑制する.
class _MapStatefulStream<T, S> implements StateStream<T> {
  /// 変換元の [StateStream].
  final StateStream<S> _source;

  /// 状態変換関数.
  final T Function(S) _mapper;

  /// [_source] と [_mapper] から変換Streamを作成する.
  ///
  /// Example:
  /// ```dart
  /// // 通常は StateStream.map 経由で生成する.
  /// final labels = counter.map((n) => 'count=$n');
  /// ```
  _MapStatefulStream(this._source, this._mapper);

  /// [_mapper] で変換した現在値.
  @override
  T get state => _mapper(_source.state);

  /// [_mapper] で変換した通知Stream.
  ///
  /// 連続同一値はdistinctで抑制する.
  @override
  Stream<T> get stream => _source.stream.map(_mapper).distinct();
}

/// [StateStream] の変換拡張.
extension StatefulStreamExtension<T> on StateStream<T> {
  /// 状態を別の型に変換する.
  ///
  /// [mapper] は冪等であることが望ましい（UI向けViewState生成など）.
  /// 変換後のStreamは連続同一値をdistinctで落とす.
  ///
  /// Example:
  /// ```dart
  /// final labels = counter.map((n) => 'count=$n');
  /// print(labels.state);
  /// ```
  StateStream<S> map<S>(S Function(T) mapper) {
    return _MapStatefulStream(this, mapper);
  }
}
