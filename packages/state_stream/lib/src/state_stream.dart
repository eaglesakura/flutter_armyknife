import 'package:rxdart/rxdart.dart';

/// 現在の状態と通知を受け取るためのStreamを提供するインターフェース.
/// 状態から冪等な別状態（StateからUI情報等）を生成するためのmapメソッドを提供する.
abstract class StateStream<T> {
  /// [BehaviorSubject]から[StateStream]を生成する.
  factory StateStream.fromBehaviorSubject(BehaviorSubject<T> stream) {
    return _BehaviorSubjectStatefulStream(stream);
  }

  /// 現在の値
  T get state;

  /// 値を通知するStream
  Stream<T> get stream;
}

class _BehaviorSubjectStatefulStream<T> implements StateStream<T> {
  final BehaviorSubject<T> _subject;

  _BehaviorSubjectStatefulStream(this._subject);

  @override
  T get state => _subject.value;

  @override
  Stream<T> get stream => _subject.stream;
}
