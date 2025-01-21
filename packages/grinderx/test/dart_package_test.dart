import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:grinderx/grinderx.dart';
import 'package:test/test.dart';

void main() {
  final skipWorkspaceTest = true;

  test('pubspecを読み込める', () async {
    final pubspec = DartPackage(
      directory: Directory.current,
    );

    expect(pubspec.name, 'grinderx');
    expect(pubspec.isFlutter, isFalse);
    expect(pubspec.hasTests, isTrue);
    expect(pubspec.hasBuildRunner, isFalse);
  });

  test('workspaceを読み込める', () async {
    final pubspec = DartPackage(
      directory: Directory.current.parent.parent,
    );

    expect(pubspec.workspacePackages, isNotEmpty);
  }, skip: skipWorkspaceTest);

  test('flutterプロジェクトを判定できる', () async {
    final pubspec = DartPackage(
      directory: joinDir(Directory.current.parent, ['future_contextx']),
    );

    expect(pubspec.isFlutter, isTrue);
  });
}
