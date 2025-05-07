import 'dart:io';

import 'package:dartxx/dartxx.dart';
import 'package:grinder/grinder.dart';
import 'package:loggerx/loggerx.dart';
import 'package:yamlx/yamlx.dart';

final _log = Logger.of(Xcodegen);

/// xcodegenの実行を行う.
class Xcodegen {
  /// Yaml設定値
  ///
  /// ```yaml
  /// xcodegen:
  ///   env:
  ///     KEY: VALUE
  /// ```
  final Map configurations;

  /// project.yaml
  /// e.g. 'app/ios'
  final Directory iosDirectory;

  const Xcodegen({
    required this.configurations,
    required this.iosDirectory,
  });

  /// xcodegenを実行する
  Future run() async {
    final environment = YamlX.find<Map<dynamic, dynamic>>(
            configurations, ['xcodegen', 'env']) ??
        {};

    _log.i('xcodegen');
    for (final kv in environment.entries) {
      _log.i('  - ${kv.key}: ${kv.value}');
    }

    await runAsync(
      'xcodegen',
      runOptions: RunOptions(
        includeParentEnvironment: true,
        environment: environment.entries
            .map((e) => MapEntry(e.key.toString(), e.value.toString()))
            .toMap(),
        workingDirectory: iosDirectory.absolute.path,
      ),
    );
  }
}
