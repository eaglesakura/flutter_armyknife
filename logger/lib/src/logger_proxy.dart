// ignore_for_file: avoid_print

/// ログ出力を行うためのProxy.
/// 必要に応じて出力関数を切り替える.
final class LoggerProxy {
  const LoggerProxy._();

  /// infoレベル出力関数
  static Function(String tag, String message) i = _DefaultLogImpl.i;

  /// debugレベル出力関数
  static Function(String tag, String message) d = _DefaultLogImpl.d;

  /// errorレベル出力関数
  static Function(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ])
  e = _DefaultLogImpl.e;

  /// warningレベル出力関数
  static Function(String tag, String message) w = _DefaultLogImpl.w;
}

/// デフォルト実装のログ出力.
final class _DefaultLogImpl {
  static void d(String tag, String message) {
    print(_format(tag, message));
  }

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

  static void i(String tag, String message) {
    print(_format(tag, message));
  }

  static void w(String tag, String message) {
    print(_format(tag, message));
  }

  static String _format(String tag, String msg) => '[$tag] $msg';
}
