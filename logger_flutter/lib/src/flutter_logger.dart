import 'dart:io';

import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as impl;

/// LoggerインターフェースをFlutter用に初期化する.
///
/// `package:logger` のPrettyPrinterを使い、プラットフォームごとに色・絵文字の有無を切り替える.
final class FlutterLogger {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// FlutterLogger.inject();
  /// ```
  const FlutterLogger._();

  /// [LoggerProxy] をflutter用の出力に指定する.
  ///
  /// 副作用として [LoggerProxy] の静的関数ポインタを上書きする.
  /// アプリ起動直後など、ログ利用前に一度だけ呼ぶ想定.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   FlutterLogger.inject();
  ///   runApp(const MyApp());
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
/// 端末・Webごとに色と絵文字の可否を決め、PrettyPrinter経由で出力する.
final class _DefaultLogImpl {
  /// 色付き出力を有効にするかどうか.
  ///
  /// Webとデスクトップは有効、Android/iOSは無効.
  static final _withColorOutput = () {
    if (kIsWeb) {
      return true;
    } else if (Platform.isAndroid || Platform.isIOS) {
      return false;
    }

    return true;
  }();

  /// 絵文字付き出力を有効にするかどうか.
  ///
  /// iOS以外は有効、iOSは無効.
  static final _withEmoji = () {
    if (kIsWeb) {
      return true;
    } else if (Platform.isIOS) {
      return false;
    }
    return true;
  }();

  /// Infoレベル向けのPrettyPrinter実装.
  static final impl.Logger _infoImpl = impl.Logger(
    printer: impl.PrettyPrinter(
      lineLength: 120,
      stackTraceBeginIndex: 2,
      printEmojis: _withEmoji,
      noBoxingByDefault: true,
      colors: _withColorOutput,
    ),
  );

  /// Warning/Debug/Error向けのPrettyPrinter実装.
  ///
  /// 時刻表示を有効にした設定を共有する.
  static final impl.Logger _warningImpl = impl.Logger(
    printer: impl.PrettyPrinter(
      lineLength: 120,
      stackTraceBeginIndex: 2,
      printEmojis: _withEmoji,
      dateTimeFormat: impl.DateTimeFormat.onlyTime,
      colors: _withColorOutput,
    ),
  );

  /// DebugレベルをPrettyPrinter経由で出力する.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.d('ui', 'rebuild');
  /// ```
  static void d(String tag, String message) {
    _warningImpl.d(_format(tag, message));
  }

  /// ErrorレベルをPrettyPrinter経由で出力する.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  /// [error] / [stackTrace] がある場合は付随情報として渡す.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.e('api', 'failed', Exception('x'));
  /// ```
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

  /// InfoレベルをPrettyPrinter経由で出力する.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.i('boot', 'ready');
  /// ```
  static void i(String tag, String message) {
    _infoImpl.i(_format(tag, message));
  }

  /// WarningレベルをPrettyPrinter経由で出力する.
  ///
  /// [tag] は行頭の識別子、[message] は本文.
  ///
  /// Example:
  /// ```dart
  /// _DefaultLogImpl.w('cache', 'miss');
  /// ```
  static void w(String tag, String message) {
    _warningImpl.w(_format(tag, message));
  }

  /// `[tag] msg` 形式の1行文字列へ整形する.
  ///
  /// [tag] は括弧内の識別子、[msg] は本文.
  ///
  /// Example:
  /// ```dart
  /// final line = _DefaultLogImpl._format('api', 'ok');
  /// ```
  static String _format(String tag, String msg) => '[$tag] $msg';
}
