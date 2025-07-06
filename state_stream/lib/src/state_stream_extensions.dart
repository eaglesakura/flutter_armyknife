import 'package:state_stream/src/state_stream.dart';

class _MapStatefulStream<T, S> implements StateStream<T> {
  final StateStream<S> _source;
  final T Function(S) _mapper;

  _MapStatefulStream(this._source, this._mapper);

  @override
  T get state => _mapper(_source.state);

  @override
  Stream<T> get stream => _source.stream.map(_mapper).distinct();
}

extension StatefulStreamExtension<T> on StateStream<T> {
  /// 状態を別の型に変換する.
  StateStream<S> map<S>(S Function(T) mapper) {
    return _MapStatefulStream(this, mapper);
  }
}
