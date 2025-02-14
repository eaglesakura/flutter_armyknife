import 'package:rxdart/rxdart.dart';

/// 現在の状態と通知を受け取るためのStreamを提供するインターフェース.
/// 状態から冪等な別状態（StateからUI情報等）を生成するためのmapメソッドを提供する.
@Deprecated('Use state_stream package')
abstract class StateStream<T> {
  /// [BehaviorSubject]から[StateStream]を生成する.
  factory StateStream.fromBehaviorSubject(BehaviorSubject<T> stream) {
    return _BehaviorSubjectStatefulStream(stream);
  }

  /// 値を通知するStream
  Stream<T> get stream;

  /// 現在の値
  T get state;
}

@Deprecated('Use state_stream package')
extension StatefulStreamExtension<T> on StateStream<T> {
  /// 状態を別の型に変換する.
  StateStream<S> map<S>(S Function(T) mapper) {
    return _MapStatefulStream(this, mapper);
  }
}

@Deprecated('Use state_stream package')
class _BehaviorSubjectStatefulStream<T> implements StateStream<T> {
  final BehaviorSubject<T> _subject;

  _BehaviorSubjectStatefulStream(this._subject);

  @override
  Stream<T> get stream => _subject.stream;

  @override
  T get state => _subject.value;
}

@Deprecated('Use state_stream package')
class _MapStatefulStream<T, S> implements StateStream<T> {
  final StateStream<S> _source;
  final T Function(S) _mapper;

  _MapStatefulStream(this._source, this._mapper);

  @override
  Stream<T> get stream => _source.stream.map(_mapper).distinct();

  @override
  T get state => _mapper(_source.state);
}
