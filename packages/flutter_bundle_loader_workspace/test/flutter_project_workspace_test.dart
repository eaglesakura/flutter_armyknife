// ignore_for_file: avoid_print

import 'package:flutter_bundle_loader_workspace/flutter_asset_loader_workspace.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('列挙', () {
    final workspace = FlutterProjectWorkspace();
    final packages = workspace.listPackages();
    for (final package in packages) {
      print(package.path);
    }
  });
}
