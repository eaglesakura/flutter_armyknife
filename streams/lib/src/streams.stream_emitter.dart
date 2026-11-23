part of 'streams.dart';

/// Streamの値を送信するインターフェース.
///
/// [Streams.generate] の送信構造を隠蔽するために使用される.
final class StreamEmitter<T> {
  /// 送受信に使う内部 [Subject].
  final Subject<dynamic> _subject;

  /// [_subject] へ値を送るEmitterを作成する.
  ///
  /// Example:
  /// ```dart
  /// // Streams.generate 内でのみ生成される.
  /// final stream = Streams.generate<int>((emitter) async {
  ///   await emitter.emit(1);
  /// });
  /// ```
  StreamEmitter._(this._subject);

  /// Streamがすでに閉じられている場合はtrue.
  bool get isClosed => _subject.isClosed;

  /// Streamに値を投げる.
  ///
  /// [isClosed] がtrueの場合は何もしない.
  ///
  /// Example:
  /// ```dart
  /// await Streams.generate<int>((emitter) async {
  ///   emitter.value = 1;
  /// });
  /// ```
  set value(T value) {
    if (!isClosed) {
      _subject.add(value);
    }
  }

  /// Streamに値を投げる.
  ///
  /// [isClosed] がtrueの場合は何もしない.
  ///
  /// Example:
  /// ```dart
  /// await Streams.generate<int>((emitter) async {
  ///   await emitter.emit(1);
  /// });
  /// ```
  Future<T> emit(T value) async {
    if (!isClosed) {
      _subject.add(value);
      await nop();
    }
    return value;
  }
}
