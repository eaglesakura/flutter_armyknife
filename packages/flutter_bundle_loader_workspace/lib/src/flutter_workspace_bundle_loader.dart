import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:data_reference/data_reference.dart';
import 'package:flutter_bundle_loader/flutter_bundle_loader.dart';
import 'package:flutter_bundle_loader_workspace/src/flutter_project_workspace.dart';
import 'package:path/path.dart' as p;
import 'package:yamlx/yamlx.dart';

/// Unit TestでWorkspaceからデータを読み込むためのLoader.
class FlutterWorkspaceBundleLoader implements FlutterBundleLoader {
  final workspace = FlutterProjectWorkspace();

  /// 読み込み関数.
  final DataReference? Function({
    /// packageが格納されているディレクトリ
    required Directory packageDirectory,

    /// 読み込み対象のパス
    required String path,

    /// 読み込み対象のパッケージ名
    String? package,
  }) loadBundle;

  FlutterWorkspaceBundleLoader({
    this.loadBundle = _defaultLoadBundle,
  });

  @override
  DataReference load({required String path, String? package}) {
    return workspace
        .listPackages()
        .map((packageDirectory) {
          return loadBundle(
            packageDirectory: packageDirectory,
            path: path,
            package: package,
          );
        })
        .whereNotNull()
        .first;
  }

  static DataReference? _defaultLoadBundle({
    /// packageが格納されているディレクトリ
    required Directory packageDirectory,

    /// 読み込み対象のパス
    required String path,

    /// 読み込み対象のパッケージ名
    String? package,
  }) {
    final pubspecYaml =
        YamlX.parse(File(p.join(packageDirectory.path, 'pubspec.yaml')));
    final packageName = YamlX.require(pubspecYaml, ['name']);
    if (package != null && package != packageName) {
      return null;
    }

    final file = File(p.join(packageDirectory.path, path));
    if (!file.existsSync()) {
      return null;
    }
    return DataReference.file(file);
  }
}
