import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:grinderx/src/grinder_context_extensions.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart' as yaml;
import 'package:yamlx/yamlx.dart';

/// pubspec.yamlが存在するディレクトリをDartPackageとして扱うクラス.
///
/// packageのメタデータ取得やコマンド実行を行う.
class DartPackage {
  /// pubspec.yamlが存在するディレクトリ
  final Directory directory;

  /// package名
  final String name;

  /// Flutterプロジェクトであればtrue.
  final bool isFlutter;

  /// build_runnerがdev_dependenciesに含まれていればtrue.
  /// trueの場合はbuild_runnerの実行対象となる.
  final bool hasBuildRunner;

  /// Dart Workspaceに登録されているpackageリスト.
  final List<DartPackage> workspacePackages;

  /// 指定ディレクトリをDart Packageとして読み込む.
  /// pubspec.yamlが存在しない場合はエラーを投げる.
  factory DartPackage({
    required Directory directory,
  }) {
    final root = directory.absolute;
    if (!root.existsSync()) {
      throw ArgumentError('Directory not found: ${root.path}');
    }
    final pubspecFile = joinFile(root, ['pubspec.yaml']);
    final pubspec = yaml.loadYaml(pubspecFile.readAsStringSync()) as Map;

    final name = YamlX.require<String>(pubspec, ['name']);
    final dependencies = YamlX.find<Map?>(pubspec, ['dependencies']) ?? {};
    final isFlutter =
        YamlX.find<String>(dependencies, ['flutter', 'sdk']) == 'flutter';
    final devDependencies =
        YamlX.find<Map?>(pubspec, ['dev_dependencies']) ?? {};
    final hasBuildRunner = devDependencies.containsKey('build_runner');
    final workspace = YamlX.find<List?>(pubspec, ['workspace']) ?? [];

    return DartPackage._(
      directory: root,
      name: name,
      isFlutter: isFlutter,
      hasBuildRunner: hasBuildRunner,
      workspacePackages: workspace
          .map((e) => joinDir(root, [e.toString()]))
          .whereType<Directory>()
          .map((e) => DartPackage(directory: e))
          .toList(),
    );
  }

  DartPackage._({
    required this.directory,
    required this.isFlutter,
    required this.name,
    required this.hasBuildRunner,
    required this.workspacePackages,
  });

  /// 相対パスからDirectoryを取得する.
  Directory relativeDirectory(String relativePath) {
    return Directory(p.normalize(p.join(directory.path, relativePath)));
  }

  /// 相対パスからFileを取得する.
  File relativeFile(String relativePath) {
    return File(p.normalize(p.join(directory.path, relativePath)));
  }

  /// テストファイルが存在するかどうかを返す.
  bool get hasTests {
    final testDirectory = relativeDirectory('test');
    if (!testDirectory.existsSync()) {
      return false;
    }
    return testDirectory
        .listSync(recursive: true)
        .where((entity) => entity.path.endsWith('_test.dart'))
        .isNotEmpty;
  }

  /// flutter analyze.
  Future analyze() async {
    _log('flutter analyze $name');
    await runDartOrFlutter(
      'analyze',
      args: ['lib'],
    );

    if (hasTests) {
      await runDartOrFlutter(
        'analyze',
        args: ['test'],
      );
    }
  }

  /// flutter clean
  Future clean() async {
    _log('flutter clean $name');
    if (isFlutter) {
      await runFlutter('clean');
    }
  }

  /// 指定ファイルが含まれるpackageを取得する.
  DartPackage? findPackageFromFocusFile(File file) {
    var directory = file.parent;
    while (directory.path.isNotEmpty) {
      final pubspec = File(p.join(directory.path, 'pubspec.yaml'));
      if (pubspec.existsSync()) {
        _log('pubspec: ${pubspec.path}');
        final result =
            [
              this,
              ...workspacePackages,
            ].where(
              (pub) {
                return p.equals(pub.directory.path, directory.path);
              },
            ).firstOrNull;
        _log('focus: ${result?.directory.path}');
        return result;
      }
      directory = directory.parent.absolute;
    }
    return null;
  }

  /// Dartコードのフォーマッタを適用する.
  Future format() async {
    _log('dart format $name');
    for (final dir in ['lib/', 'test/']) {
      final target = joinDir(directory, [dir]);
      if (target.existsSync()) {
        await context.dart(
          'format',
          args: [dir],
          workingDirectory: directory.path,
        );
      }
    }
  }

  Future genL10n() async {
    if (!isFlutter) {
      _log('skip gen-l10n');
      return;
    }

    _log('flutter pub run intl_utils:generate');
    await runFlutter(
      'gen-l10n',
    );
  }

  /// build_runnerを実行する
  Future runBuildRunner() async {
    if (!hasBuildRunner) {
      _log('skip build_runner');
      return;
    }

    _log('dart build_runner $name');

    // NOTE.
    // flutter_genの不具合と思われる挙動で、n回目の上書き生成がskipされる場合がある.
    // それを回避するため、ここではflutter_genが生成したファイルを明示的に削除する.
    final cleanDirectoryList = [
      joinDir(directory, ['lib', 'gen']),
    ];

    for (final dir in cleanDirectoryList) {
      if (dir.existsSync()) {
        _log('delete: ${dir.path}');
        dir.deleteSync(recursive: true);
      }
    }

    await context.dart(
      'run',
      args: ['build_runner', 'build', '--delete-conflicting-outputs'],
      workingDirectory: directory.path,
    );

    final libDirectory = joinDir(directory, ['lib']);
    if (libDirectory.existsSync()) {
      libDirectory
          .listSync(recursive: true)
          .where((entity) => entity.path.endsWith('.freezed.dart'))
          .whereType<File>()
          .forEach((file) {
            // freezed出力時、Unionで異なる型・同一プロパティ名があると
            // "InvalidType" という型名が生成されるため、dynamicに変換する
            final content = file.readAsStringSync().replaceAll(
              'InvalidType',
              'dynamic',
            );
            file.writeAsStringSync(content);
          });
    }
    await format();
  }

  /// dartコマンドを実行する.
  Future<String> runDart(
    String subCommand, {
    List<String> args = const [],
    Map<String, String> environment = const {},
  }) {
    _log('dart $subCommand $args');
    return context.dart(
      subCommand,
      args: args,
      workingDirectory: directory.path,
      environment: environment,
    );
  }

  /// dartコマンド、もしくはflutterコマンドの適切なほうを実行する.
  Future<String> runDartOrFlutter(
    String subCommand, {

    /// 引数
    List<String> args = const [],

    /// 追加の環境変数
    Map<String, String> environment = const {},
  }) {
    if (isFlutter) {
      return runFlutter(
        subCommand,
        args: args,
        environment: environment,
      );
    } else {
      return runDart(
        subCommand,
        args: args,
        environment: environment,
      );
    }
  }

  /// flutterコマンドを実行する.
  Future<String> runFlutter(
    String subCommand, {
    List<String> args = const [],
    Map<String, String> environment = const {},
  }) {
    _log('flutter $subCommand $args');
    return context.flutter(
      subCommand,
      args: args,
      workingDirectory: directory.path,
      environment: environment,
    );
  }

  /// flutter testを実行する
  /// テストファイルが存在しない場合はテストをスキップする.
  Future test({
    bool withWorkspace = true,
  }) async {
    if (hasTests) {
      _log('flutter test $name');
      await runDartOrFlutter(
        'test',
        args: [],
      );
    } else {
      _log('skip test');
    }

    if (withWorkspace) {
      for (final pkg in workspacePackages) {
        await pkg.test(withWorkspace: false);
      }
    }
  }

  /// コードフォーマッタを実行し、未設定のファイルがあればエラーを出力する.
  Future validateFormat() async {
    _log('dart format $name');
    for (final dir in ['lib/', 'test/']) {
      final target = joinDir(directory, [dir]);
      if (target.existsSync()) {
        await context.dart(
          'format',
          args: [
            dir,
            '--set-exit-if-changed',
          ],
          workingDirectory: directory.path,
        );
      }
    }
  }

  /// すべてのpackageに対してactionを実行する.
  Future forEach(
    Future Function(DartPackage pkg) action, {
    bool allPackages = true,
  }) async {
    await action(this);
    if (allPackages) {
      for (final pkg in workspacePackages) {
        await pkg.forEach(action);
      }
    }
  }

  void _log(String msg) => context.log('[$name] $msg');
}
