import 'package:rxdart/rxdart.dart';

/// 現在の状態と通知を受け取るためのStreamを提供するインターフェース.
///
/// 状態から冪等な別状態（StateからUI情報等）を生成するためのmapメソッドを提供する.
abstract class StateStream<T> {
  /// [BehaviorSubject]から[StateStream]を生成する.
  ///
  /// [stream] の最新値が [state] として公開され、通知は [stream] の購読で受け取る.
  ///
  /// Example:
  /// ```dart
  /// final subject = BehaviorSubject.seeded(0);
  /// final stateStream = StateStream.fromBehaviorSubject(subject);
  /// print(stateStream.state); // 0
  /// ```
  factory StateStream.fromBehaviorSubject(BehaviorSubject<T> stream) {
    return _BehaviorSubjectStatefulStream(stream);
  }

  /// 現在の値.
  T get state;

  /// 値を通知するStream.
  Stream<T> get stream;
}

/// [BehaviorSubject] をラップした [StateStream] 実装.
class _BehaviorSubjectStatefulStream<T> implements StateStream<T> {
  /// 状態の保持と通知に使う [BehaviorSubject].
  final BehaviorSubject<T> _subject;

  /// [_subject] を保持する実装を作成する.
  ///
  /// Example:
  /// ```dart
  /// // 通常は StateStream.fromBehaviorSubject 経由で生成する.
  /// final subject = BehaviorSubject.seeded(0);
  /// final stateStream = StateStream.fromBehaviorSubject(subject);
  /// ```
  _BehaviorSubjectStatefulStream(this._subject);

  /// [_subject] の最新値.
  @override
  T get state => _subject.value;

  /// [_subject] の通知Stream.
  @override
  Stream<T> get stream => _subject.stream;
}
