import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:dartxx/dartxx.dart';
import 'package:properties/properties.dart';

/// プロジェクト全体の設定値.
///
/// *.propertiesファイルで定義された値をマージして提供する.
class ProjectProperties {
  final Properties _properties;

  const ProjectProperties(this._properties);

  /// 指定ファイル及びディレクトリを探索してプロパティを読み込む.
  factory ProjectProperties.load({
    List<File> files = const [],
    List<Directory> directories = const [],
  }) {
    if (files.isEmpty && directories.isEmpty) {
      throw ArgumentError('files or directories must be specified');
    }

    final propertyFileList = <File>[
      ...files,
    ];

    /// ディレクトリ直下のファイルは列挙する
    for (final dir in directories) {
      propertyFileList.addAll(
        dir.listSync().whereType<File>().where(
          (e) => e.path.endsWith('.properties'),
        ),
      );
    }

    final properties = Properties.fromMap({});

    for (final prop in propertyFileList) {
      if (!prop.existsSync()) {
        throw ArgumentError('Property file not found: ${prop.path}');
      }
      final extra = Properties.fromFile(prop.path);
      properties.merge(extra, true);
    }

    return ProjectProperties(properties);
  }

  /// 指定したキーが存在するか.
  bool containsKey(String key) => _properties.contains(key);

  /// Propertyから指定キーを取得.
  String get(String key, {bool requireValue = true}) {
    final value = _properties[key];
    if (value == null) {
      throw ArgumentError('Property not found: $key');
    } else if (requireValue && value.isEmpty) {
      throw ArgumentError('Property is empty: $key');
    }
    return value;
  }

  /// Propertyから指定のプレフィクスを持つMapを抽出する.
  Map<String, String> subset(
    String prefix, {

    /// trueの場合、プレフィクスを削除する.
    bool trimPrefix = true,
  }) {
    return iterator()
        .map((kv) {
          final key = kv.$1;
          final value = kv.$2;
          if (key.startsWith(prefix)) {
            final newKey = trimPrefix ? key.substring(prefix.length) : key;
            return MapEntry(newKey.trim(), value.trim());
          }
          return null;
        })
        .whereNotNull()
        .toMap();
  }

  /// 指定した優先順でプロパティを探索する.
  String getOrdered(List<String> keys, {bool requireValue = true}) {
    for (final key in keys) {
      final value = _properties[key];
      if (value != null) {
        if (requireValue) {
          if (value.isNotEmpty) {
            return value;
          }
        } else {
          return value;
        }
      }
    }
    throw ArgumentError('Property not found: $keys');
  }

  /// すべてのKey-Valueを列挙する.
  Iterable<(String key, String value)> iterator() sync* {
    final keys = _properties.keys.sorted();
    for (final key in keys) {
      yield (key, _properties[key]!);
    }
  }
}
