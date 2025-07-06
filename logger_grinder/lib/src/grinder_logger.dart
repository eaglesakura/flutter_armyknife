import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:grinder/grinder.dart';

/// LoggerインターフェースをGrinder用に初期化する.
final class GrinderLogger {
  const GrinderLogger._();

  /// [LoggerProxy] をgrinder用の出力に指定する.
  static void inject() {
    LoggerProxy.i = _DefaultLogImpl.i;
    LoggerProxy.d = _DefaultLogImpl.d;
    LoggerProxy.w = _DefaultLogImpl.w;
    LoggerProxy.e = _DefaultLogImpl.e;
  }
}

/// デフォルト実装のログ出力.
final class _DefaultLogImpl {
  static void d(String tag, String message) {
    context.log('[$tag] $message');
  }

  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    context.log('[$tag] $message, $error, $stackTrace');
  }

  static void i(String tag, String message) {
    context.log('[$tag] $message');
  }

  static void w(String tag, String message) {
    context.log('[$tag] $message');
  }
}
