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

class _LoggerImpl implements Logger {
  final String _tag;

  _LoggerImpl(this._tag);

  @override
  void d(String message) => LoggerProxy.d(_tag, message);

  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      LoggerProxy.e(_tag, message, error, stackTrace);

  @override
  void i(String message) => LoggerProxy.i(_tag, message);

  @override
  void w(String message) => LoggerProxy.w(_tag, message);
}
