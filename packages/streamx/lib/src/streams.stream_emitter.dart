part of 'streams.dart';

/// Streamの値を送信するインターフェース.
///
/// [Streams.generate] の送信構造を隠蔽するために使用される.
final class StreamEmitter<T> {
  final Subject<dynamic> _subject;

  StreamEmitter._(this._subject);

  /// Streamがすでに閉じられている場合はtrue.
  bool get isClosed => _subject.isClosed;

  /// Streamに値を投げる.
  /// [isClosed] がtrueの場合は何もしない.
  set value(T value) {
    if (!isClosed) {
      _subject.add(value);
    }
  }
}
