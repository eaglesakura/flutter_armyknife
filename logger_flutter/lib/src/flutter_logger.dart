import 'dart:io';

import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as impl;

/// LoggerインターフェースをFlutter用に初期化する.
final class FlutterLogger {
  const FlutterLogger._();

  /// [LoggerProxy] をflutter用の出力に指定する.
  static void inject() {
    LoggerProxy.i = _DefaultLogImpl.i;
    LoggerProxy.d = _DefaultLogImpl.d;
    LoggerProxy.w = _DefaultLogImpl.w;
    LoggerProxy.e = _DefaultLogImpl.e;
  }
}

/// デフォルト実装のログ出力.
final class _DefaultLogImpl {
  static final _withColorOutput = () {
    if (kIsWeb) {
      return true;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return false;
    }

    return true;
  }();

  static final _withEmoji = () {
    if (kIsWeb) {
      return true;
    } else if (Platform.isIOS) {
      return false;
    }
    return true;
  }();

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
