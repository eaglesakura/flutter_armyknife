part of 'logger.dart';

/// コールバックで出力先を差し替える [Logger] 実装.
class _CallbackImpl implements Logger {
  /// Infoレベル向けの出力コールバック.
  final void Function(String message) info;

  /// Debugレベル向けの出力コールバック.
  final void Function(String message) debug;

  /// Warningレベル向けの出力コールバック.
  final void Function(String message) warning;

  /// Errorレベル向けの出力コールバック.
  final void Function(String message, [dynamic error, StackTrace? stackTrace])
  error;

  /// 各レベルのコールバックを保持する実装を生成する.
  ///
  /// [info] / [debug] / [warning] / [error] は対応するレベル呼び出し時に実行される.
  ///
  /// Example:
  /// ```dart
  /// final logger = _CallbackImpl(
  ///   info: print,
  ///   debug: print,
  ///   warning: print,
  ///   error: (msg, [error, stackTrace]) => print(msg),
  /// );
  /// ```
  _CallbackImpl({
    required this.info,
    required this.debug,
    required this.warning,
    required this.error,
  });

  /// Debugレベルのログを [debug] コールバックへ渡す.
  ///
  /// [message] はコールバックへそのまま渡される.
  ///
  /// Example:
  /// ```dart
  /// _CallbackImpl(
  ///   info: print,
  ///   debug: print,
  ///   warning: print,
  ///   error: (msg, [error, stackTrace]) => print(msg),
  /// ).d('debug');
  /// ```
  @override
  void d(String message) => debug(message);

  /// Errorレベルのログを保持コールバックへ渡す.
  ///
  /// [message] / [error] / [stackTrace] はコールバックへそのまま渡される.
  ///
  /// Example:
  /// ```dart
  /// _CallbackImpl(
  ///   info: print,
  ///   debug: print,
  ///   warning: print,
  ///   error: (msg, [error, stackTrace]) => print(msg),
  /// ).e('failed', Exception('x'));
  /// ```
  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      error(message, error, stackTrace);

  /// Infoレベルのログを [info] コールバックへ渡す.
  ///
  /// [message] はコールバックへそのまま渡される.
  ///
  /// Example:
  /// ```dart
  /// _CallbackImpl(
  ///   info: print,
  ///   debug: print,
  ///   warning: print,
  ///   error: (msg, [error, stackTrace]) => print(msg),
  /// ).i('info');
  /// ```
  @override
  void i(String message) => info(message);

  /// Warningレベルのログを [warning] コールバックへ渡す.
  ///
  /// [message] はコールバックへそのまま渡される.
  ///
  /// Example:
  /// ```dart
  /// _CallbackImpl(
  ///   info: print,
  ///   debug: print,
  ///   warning: print,
  ///   error: (msg, [error, stackTrace]) => print(msg),
  /// ).w('warn');
  /// ```
  @override
  void w(String message) => warning(message);
}

/// すべてのログ呼び出しを破棄する [Logger] 実装.
class _DropLogger implements Logger {
  /// Debugレベルの呼び出しを破棄する.
  ///
  /// [message] は使用されない.
  ///
  /// Example:
  /// ```dart
  /// _DropLogger().d('ignored');
  /// ```
  @override
  void d(String message) {}

  /// Errorレベルの呼び出しを破棄する.
  ///
  /// [message] / [error] / [stackTrace] は使用されない.
  ///
  /// Example:
  /// ```dart
  /// _DropLogger().e('ignored');
  /// ```
  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) {}

  /// Infoレベルの呼び出しを破棄する.
  ///
  /// [message] は使用されない.
  ///
  /// Example:
  /// ```dart
  /// _DropLogger().i('ignored');
  /// ```
  @override
  void i(String message) {}

  /// Warningレベルの呼び出しを破棄する.
  ///
  /// [message] は使用されない.
  ///
  /// Example:
  /// ```dart
  /// _DropLogger().w('ignored');
  /// ```
  @override
  void w(String message) {}
}

/// [LoggerProxy] へタグ付きで委譲する標準実装.
class _LoggerImpl implements Logger {
  /// ログ行頭に付与するタグ.
  final String _tag;

  /// [_tag] を保持する実装を生成する.
  ///
  /// Example:
  /// ```dart
  /// final logger = _LoggerImpl('api');
  /// logger.i('ok');
  /// ```
  _LoggerImpl(this._tag);

  /// Debugレベルのログを [LoggerProxy.d] へ委譲する.
  ///
  /// [message] はタグ付きで出力される.
  ///
  /// Example:
  /// ```dart
  /// _LoggerImpl('api').d('request');
  /// ```
  @override
  void d(String message) => LoggerProxy.d(_tag, message);

  /// Errorレベルのログを [LoggerProxy.e] へ委譲する.
  ///
  /// [message] / [error] / [stackTrace] はタグ付きで出力される.
  ///
  /// Example:
  /// ```dart
  /// _LoggerImpl('api').e('failed', Exception('x'));
  /// ```
  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      LoggerProxy.e(_tag, message, error, stackTrace);

  /// Infoレベルのログを [LoggerProxy.i] へ委譲する.
  ///
  /// [message] はタグ付きで出力される.
  ///
  /// Example:
  /// ```dart
  /// _LoggerImpl('api').i('ok');
  /// ```
  @override
  void i(String message) => LoggerProxy.i(_tag, message);

  /// Warningレベルのログを [LoggerProxy.w] へ委譲する.
  ///
  /// [message] はタグ付きで出力される.
  ///
  /// Example:
  /// ```dart
  /// _LoggerImpl('api').w('retry');
  /// ```
  @override
  void w(String message) => LoggerProxy.w(_tag, message);
}
