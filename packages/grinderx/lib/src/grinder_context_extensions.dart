import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart' as p;

/// dartコマンド
final _dart = Platform.isWindows ? 'dart.bat' : 'dart';

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
