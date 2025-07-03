import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:loggerx/loggerx.dart';
import 'package:path/path.dart' as p;

// /// fvmコマンド
// final _fvm = Platform.isWindows ? 'fvm.bat' : 'fvm';

/// flutterコマンド
final _flutter = Platform.isWindows ? 'flutter.bat' : 'flutter';

/// dartコマンド
final _dart = Platform.isWindows ? 'dart.exe' : 'dart';

extension GrinderContextExtensions on GrinderContext {
  String _normalizedPath(String path) {
    return p.normalize(path);
  }

  /// 指定パスのファイルを取得する.
  File file(String relativePath) =>
      File(_normalizedPath(relativePath)).absolute;

  /// 指定パスのディレクトリを取得する.
  Directory directory(String relativePath) =>
      Directory(_normalizedPath(relativePath)).absolute;

  /// Logインターフェースを生成する.
  Logger logger({
    String? tag,
  }) {
    void impl(String message) {
      if (tag != null) {
        log('[$tag] $message');
      } else {
        log(message);
      }
    }

    return Logger.create(
      info: impl,
      debug: impl,
      warning: impl,
      error: (msg, [error, stackTrace]) => impl('$msg\n$error\n$stackTrace'),
    );
  }

  /// flutterコマンドを実行する.
  /// fvmもしくはPATHのflutterコマンドを実行する.
  Future<String> flutter(
    String subCommand, {

    /// 引数
    List<String> args = const [],

    /// 実行ディレクトリ
    String? workingDirectory,

    /// 追加の環境変数
    Map<String, String> environment = const {},
  }) async {
    return runAsync(
      _flutter,
      arguments: [
        subCommand,
        ...args,
      ],
      runOptions: RunOptions(
        workingDirectory: workingDirectory,
        environment: environment,
      ),
    );
  }

  /// dartコマンドを実行する.
  /// fvmもしくはPATHのdartコマンドを実行する.
  Future<String> dart(
    String subCommand, {
    List<String> args = const [], // 引数
    String? workingDirectory, // 実行ディレクトリ
    Map<String, String> environment = const {}, // 追加の環境変数
  }) async {
    return runAsync(
      _dart,
      arguments: [
        subCommand,
        ...args,
      ],
      runOptions: RunOptions(
        workingDirectory: workingDirectory,
        environment: environment,
      ),
    );
  }
}
