part of 'logger.dart';

class _CallbackImpl implements Logger {
  final void Function(String message) info;
  final void Function(String message) debug;
  final void Function(String message) warning;
  final void Function(String message, [dynamic error, StackTrace? stackTrace])
      error;

  _CallbackImpl({
    required this.info,
    required this.debug,
    required this.warning,
    required this.error,
  });

  @override
  void d(String message) => debug(message);

  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      error(message, error, stackTrace);

  @override
  void i(String message) => info(message);

  @override
  void w(String message) => warning(message);
}

class _LoggerImpl implements Logger {
  static final _withColorOutput = !PlatformX.isAndroid && !PlatformX.isIOS;
  static final _withEmoji = !PlatformX.isIOS;

  final String _tag;

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

  _LoggerImpl(this._tag);

  @override
  void d(String message) {
    _warningImpl.d(_format(message));
  }

  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _warningImpl.e(
      _format(message),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void i(String message) {
    _infoImpl.i(_format(message));
  }

  @override
  void w(String message) {
    _warningImpl.w(_format(message));
  }

  String _format(String msg) => '[$_tag] $msg';
}

class _DropLogger implements Logger {
  @override
  void d(String message) {}

  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) {}

  @override
  void i(String message) {}

  @override
  void w(String message) {}
}
