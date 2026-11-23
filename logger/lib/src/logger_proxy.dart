// ignore_for_file: avoid_print

/// ログ出力を行うためのProxy.
///
/// 必要に応じて出力関数を切り替える.
/// 既定では [_DefaultLogImpl] の `print` 出力が設定されている.
final class LoggerProxy {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // 静的フィールドのみを利用する.
  /// LoggerProxy.i('tag', 'message');
  /// ```
  const LoggerProxy._();

  /// infoレベル出力関数.
  ///
  /// 起動時や `inject` で差し替える想定の可変関数ポインタ.
  static Function(String tag, String message) i = _DefaultLogImpl.i;

  /// debugレベル出力関数.
  ///
  /// 起動時や `inject` で差し替える想定の可変関数ポインタ.
  static Function(String tag, String message) d = _DefaultLogImpl.d;

  /// errorレベル出力関数.
  ///
  /// 起動時や `inject` で差し替える想定の可変関数ポインタ.
  static Function(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ])
  e = _DefaultLogImpl.e;

  /// warningレベル出力関数.
  ///
  /// 起動時や `inject` で差し替える想定の可変関数ポインタ.
  static Function(String tag, String message) w = _DefaultLogImpl.w;
}

/// デフォルト実装のログ出力.
///
/// 標準出力へ `[tag] message` 形式で書き出す.
final class _DefaultLogImpl {
  /// Debugレベルを標準出力へ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.d('api', 'request');
  /// ```
  static void d(String tag, String message) {
    print(_format(tag, message));
  }

  /// Errorレベルを標準出力へ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  /// [error] / [stackTrace] がある場合は追記する.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.e('api', 'failed', Exception('x'));
  /// ```
  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    print(_format(tag, message));
    if (error != null) {
      print(_format(tag, 'error: $error'));
    }
    if (stackTrace != null) {
      print(_format(tag, 'stackTrace: $stackTrace'));
    }
  }

  /// Infoレベルを標準出力へ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.i('boot', 'ready');
  /// ```
  static void i(String tag, String message) {
    print(_format(tag, message));
  }

  /// Warningレベルを標準出力へ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.w('cache', 'miss');
  /// ```
  static void w(String tag, String message) {
    print(_format(tag, message));
  }

  /// `[tag] msg` 形式の1行文字列へ整形する.
  ///
  /// [tag] は括弧内の識別子、[msg] は本文.
  ///
  /// Example:
  /// ```dart
  /// final line = _DefaultLogImpl._format('api', 'ok');
  /// ```
  static String _format(String tag, String msg) => '[$tag] $msg';
}
