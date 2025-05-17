import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yamlx/yamlx.dart';

/// Flutterアプリプロジェクトのワークスペース情報.
class FlutterProjectWorkspace {
  /// ワークスペースのルートディレクトリ
  final Directory workspace;

  factory FlutterProjectWorkspace() {
    final root = findRoot(Directory.current);
    return FlutterProjectWorkspace._(workspace: root);
  }

  const FlutterProjectWorkspace._({
    required this.workspace,
  });

  /// ワークスペース配下のパッケージ一覧を取得する.
  Iterable<Directory> listPackages() sync* {
    yield workspace;

    // workspace配下の情報を取得
    final yaml = YamlX.parse(File(p.join(workspace.path, 'pubspec.yaml')));
    final packages = YamlX.require<List>(
      yaml,
      ['workspace'],
    );
    for (final package in packages) {
      final path = package.toString();
      yield Directory(p.join(workspace.path, path));
    }
  }

  /// 指定されたパッケージのディレクトリを取得する.
  Directory requirePackage(String packageName) {
    for (final directory in listPackages()) {
      final pubspecYaml = File(p.join(directory.path, 'pubspec.yaml'));
      if (!pubspecYaml.existsSync()) {
        continue;
      }
      final yaml = YamlX.parse(pubspecYaml);
      final name = YamlX.require(yaml, ['name']);
      if (name == packageName) {
        return directory;
      }
    }

    throw Exception('Package $packageName not found');
  }

  @internal
  static Directory findRoot(Directory current) {
    // pubspec.yamlが存在するディレクトリを探す.
    final pubspecYaml = File(p.join(current.path, 'pubspec.yaml'));
    if (!pubspecYaml.existsSync()) {
      // 一つ上を探索
      return findRoot(current.parent);
    }

    // yamlロード
    final yaml = YamlX.parse(pubspecYaml);

    // workspace属性を取得
    final workspace = YamlX.find(yaml, ['workspace']);
    if (workspace == null || workspace is! List) {
      // 一つ上を探索
      return findRoot(current.parent);
    }

    return current;
  }
}
