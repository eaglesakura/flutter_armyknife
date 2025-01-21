import 'package:dartxx/dartxx.dart';
import 'package:logger/logger.dart' as impl;
import 'package:platformx/platformx.dart';

part 'logger.impl.dart';

/// ログ出力を行うためのクラス.
abstract class Logger {
  /// 他のLoggerをラップして、ログ出力を抑制する.
  /// 特定条件でログ出力を抑制する（もしくはログを出力する）際に使用する.
  factory Logger.drop(Logger origin, {bool drop = true}) {
    if (drop) {
      return _DropLogger();
    } else {
      return origin;
    }
  }

  /// コールバック関数を指定してLoggerを生成する.
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
  factory Logger.file() =>
      _LoggerImpl(StackTraceX.currentFileName(popLevel: 1));

  /// 型を指定してLoggerを生成する.
  /// ログヘッダに型名が付与される.
  factory Logger.of(Type type) => _LoggerImpl('$type');

  /// タグを指定してLoggerを生成する.
  /// ログヘッダにタグが付与される.
  factory Logger.tag(String tag) => _LoggerImpl(tag);

  /// Debugレベルのログを出力する.
  void d(String message);

  /// Errorレベルのログを出力する.
  void e(String message, [dynamic error, StackTrace? stackTrace]);

  /// Infoレベルのログを出力する.
  void i(String message);

  /// Warningレベルのログを出力する.
  void w(String message);
}
