import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:armyknife_logger/src/logger_proxy.dart';

part 'logger.impl.dart';

/// ログ出力を行うためのクラス.
///
/// 実体の出力先は [LoggerProxy] が保持する関数に委譲する.
/// プラットフォーム固有の出力は `armyknife_logger_flutter` や `armyknife_logger_grinder` の `inject` で差し替える.
abstract class Logger {
  /// 他のLoggerをラップして、ログ出力を抑制する.
  ///
  /// [drop] が `true` のとき、呼び出しを破棄する [Logger] を返す.
  /// `false` のときは [origin] をそのまま返す.
  /// 特定条件でログ出力を抑制する（もしくはログを出力する）際に使用する.
  ///
  /// Example:
  /// ```dart
  /// final enabled = false;
  /// final log = Logger.drop(Logger.tag('api'), drop: !enabled);
  /// log.i('suppressed when drop is true');
  /// ```
  factory Logger.drop(Logger origin, {bool drop = true}) {
    if (drop) {
      return _DropLogger();
    } else {
      return origin;
    }
  }

  /// コールバック関数を指定してLoggerを生成する.
  ///
  /// 未指定のレベルは `print` にフォールバックする.
  /// [info] / [debug] / [warning] / [error] は各レベルの出力先を差し替えるときに渡す.
  ///
  /// Example:
  /// ```dart
  /// final log = Logger.create(
  ///   info: (msg) => stdout.writeln(msg),
  ///   error: (msg, [error, stackTrace]) {
  ///     stderr.writeln('$msg $error');
  ///   },
  /// );
  /// log.i('ready');
  /// ```
  factory Logger.create({
    void Function(String message)? info,
    void Function(String message)? debug,
    void Function(String message)? warning,
    void Function(String message, [dynamic error, StackTrace? stackTrace])?
    error,
  }) {
    // ignore: avoid_print
    void fallback(String msg) => print(msg);

    return _CallbackImpl(
      info: info ?? fallback,
      debug: debug ?? fallback,
      warning: warning ?? fallback,
      error: error ?? ((msg, [error, stackTrace]) => fallback(msg)),
    );
  }

  /// 現在のファイル名をtagとしてLoggerを生成する.
  ///
  /// NOTE.
  /// このメソッドはStacktraceを使用するため、
  /// テスト等の補助として利用することを想定している.
  ///
  /// Example:
  /// ```dart
  /// final log = Logger.file();
  /// log.d('from current file');
  /// ```
  factory Logger.file() =>
      _LoggerImpl(StackTraceX.currentFileName(popLevel: 1));

  /// 型を指定してLoggerを生成する.
  ///
  /// ログヘッダに型名が付与される.
  /// [type] には識別したいクラスや型を渡す.
  ///
  /// Example:
  /// ```dart
  /// final log = Logger.of(MyService);
  /// log.i('started');
  /// ```
  factory Logger.of(Type type) => _LoggerImpl('$type');

  /// タグを指定してLoggerを生成する.
  ///
  /// ログヘッダにタグが付与される.
  /// [tag] にはログ行頭に付ける識別文字列を渡す.
  ///
  /// Example:
  /// ```dart
  /// final log = Logger.tag('network');
  /// log.w('timeout');
  /// ```
  factory Logger.tag(String tag) => _LoggerImpl(tag);

  /// Debugレベルのログを出力する.
  ///
  /// [message] は本文として出力される.
  ///
  /// Example:
  /// ```dart
  /// Logger.tag('ui').d('rebuild');
  /// ```
  void d(String message);

  /// Errorレベルのログを出力する.
  ///
  /// [message] は本文として出力される.
  /// [error] と [stackTrace] を渡すと、実装側で付随情報として出力できる.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await load();
  /// } catch (e, st) {
  ///   Logger.tag('load').e('failed', e, st);
  /// }
  /// ```
  void e(String message, [dynamic error, StackTrace? stackTrace]);

  /// Infoレベルのログを出力する.
  ///
  /// [message] は本文として出力される.
  ///
  /// Example:
  /// ```dart
  /// Logger.tag('boot').i('initialized');
  /// ```
  void i(String message);

  /// Warningレベルのログを出力する.
  ///
  /// [message] は本文として出力される.
  ///
  /// Example:
  /// ```dart
  /// Logger.tag('cache').w('miss');
  /// ```
  void w(String message);
}
