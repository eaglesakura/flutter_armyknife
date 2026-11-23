import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:grinder/grinder.dart';

/// LoggerインターフェースをGrinder用に初期化する.
///
/// Grinderの `context.log` へ委譲し、タスク実行ログと出力先を揃える.
final class GrinderLogger {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// GrinderLogger.inject();
  /// ```
  const GrinderLogger._();

  /// [LoggerProxy] をgrinder用の出力に指定する.
  ///
  /// 副作用として [LoggerProxy] の静的関数ポインタを上書きする.
  /// Grinderタスク定義の先頭など、ログ利用前に一度だけ呼ぶ想定.
  ///
  /// Example:
  /// ```dart
  /// void main(List<String> args) {
  ///   GrinderLogger.inject();
  ///   grind(args);
  /// }
  /// ```
  static void inject() {
    LoggerProxy.i = _DefaultLogImpl.i;
    LoggerProxy.d = _DefaultLogImpl.d;
    LoggerProxy.w = _DefaultLogImpl.w;
    LoggerProxy.e = _DefaultLogImpl.e;
  }
}

/// デフォルト実装のログ出力.
///
/// Grinderの `context.log` へ `[tag] message` 形式で書き出す.
final class _DefaultLogImpl {
  /// DebugレベルをGrinderコンテキストへ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.d('build', 'start');
  /// ```
  static void d(String tag, String message) {
    context.log('[$tag] $message');
  }

  /// ErrorレベルをGrinderコンテキストへ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  /// [error] / [stackTrace] も同一行へ連結する.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.e('build', 'failed', Exception('x'));
  /// ```
  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    context.log('[$tag] $message, $error, $stackTrace');
  }

  /// InfoレベルをGrinderコンテキストへ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.i('build', 'done');
  /// ```
  static void i(String tag, String message) {
    context.log('[$tag] $message');
  }

  /// WarningレベルをGrinderコンテキストへ書き出す.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.w('build', 'skip');
  /// ```
  static void w(String tag, String message) {
    context.log('[$tag] $message');
  }
}
