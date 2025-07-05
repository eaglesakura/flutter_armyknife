import 'package:logger/logger.dart' as impl;
import 'package:platformx/platformx.dart';

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
  static final _withColorOutput = !PlatformX.isAndroid && !PlatformX.isIOS;
  static final _withEmoji = !PlatformX.isIOS;
  static final impl.Logger _infoImpl = impl.Logger(
    printer: impl.PrettyPrinter(
      lineLength: 120,
      stackTraceBeginIndex: 2,
      printEmojis: _withEmoji,
      noBoxingByDefault: true,
      colors: _withColorOutput,
    ),
  );
  static final impl.Logger _warningImpl = impl.Logger(
    printer: impl.PrettyPrinter(
      lineLength: 120,
      stackTraceBeginIndex: 2,
      printEmojis: _withEmoji,
      dateTimeFormat: impl.DateTimeFormat.onlyTime,
      colors: _withColorOutput,
    ),
  );

  static void d(String tag, String message) {
    _warningImpl.d(_format(tag, message));
  }

  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _warningImpl.e(
      _format(tag, message),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void i(String tag, String message) {
    _infoImpl.i(_format(tag, message));
  }

  static void w(String tag, String message) {
    _warningImpl.w(_format(tag, message));
  }

  static String _format(String tag, String msg) => '[$tag] $msg';
}
