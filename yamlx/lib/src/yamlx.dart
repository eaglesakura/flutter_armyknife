import 'dart:io';

import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:yaml/yaml.dart' as yml;

/// YamlのUtil関数群.
///
/// `YamlMap` / `YamlList` を通常のMap/Listへ正規化し、パス参照で値を取り出す.
final class YamlX {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// final value = YamlX.find<String>(data, ['app', 'name']);
  /// ```
  const YamlX._();

  /// Yamlの特定pathから値を取得する.
  ///
  /// [yaml] はMap相当のツリー、[path] は辿るキー列.
  /// 途中でMap以外に当たった場合や欠落時は `null` を返す.
  ///
  /// Example:
  /// ```dart
  /// final name = YamlX.find<String>(data, ['app', 'name']);
  /// ```
  static T? find<T>(dynamic yaml, List<String> path) {
    var result = yaml;
    for (final key in path) {
      if (result is Map) {
        result = result[key];
      } else {
        return null;
      }
    }
    return result as T?;
  }

  /// シンプルなMap構造として読み込む.
  ///
  /// [file] を同期読み込みし、入れ子の `YamlMap` / `YamlList` を通常のMap/Listへ変換する.
  ///
  /// Example:
  /// ```dart
  /// final data = YamlX.parse(File('config.yaml'));
  /// ```
  static Map<String, dynamic> parse(File file) {
    final tmp = yml.loadYaml(file.readAsStringSync()) as yml.YamlMap;
    final data = <String, dynamic>{};
    _yamlMapToMap(data, tmp);
    return data;
  }

  /// 指定されたyamlファイルをマージして読み込む.
  ///
  /// [yamlFiles] を先頭から順に読み、後勝ちで深くマージする.
  ///
  /// Example:
  /// ```dart
  /// final data = YamlX.parseWithMerge([
  ///   File('base.yaml'),
  ///   File('override.yaml'),
  /// ]);
  /// ```
  static Map<String, dynamic> parseWithMerge(Iterable<File> yamlFiles) {
    final Map<String, dynamic> result = {};
    for (final file in yamlFiles) {
      result.addAll(
        MapX.merge(
          {...result},
          parse(file),
        ),
      );
    }
    return result;
  }

  /// Yamlの特定pathから値を取得する.
  ///
  /// [yaml] はMap相当のツリー、[path] は辿るキー列.
  /// 見つからない場合は [ArgumentError] を投げる.
  ///
  /// Example:
  /// ```dart
  /// final port = YamlX.require<int>(data, ['server', 'port']);
  /// ```
  static T require<T>(dynamic yaml, List<String> path) {
    final result = find<T>(yaml, path);
    if (result == null) {
      throw ArgumentError('Not found: ${path.join('.')}');
    }
    return result;
  }

  /// [yamlMap] を通常の [Map] へ再帰変換して [result] へ書き込む.
  ///
  /// Example:
  /// ```dart
  /// final out = <String, dynamic>{};
  /// YamlX._yamlMapToMap(out, yamlMap);
  /// ```
  static void _yamlMapToMap(Map<String, dynamic> result, yml.YamlMap yamlMap) {
    for (final entry in yamlMap.entries) {
      final key = entry.key.toString();
      final value = entry.value;
      if (value is yml.YamlMap) {
        final child = <String, dynamic>{};
        _yamlMapToMap(child, value);
        result[key] = child;
      } else if (value is yml.YamlList) {
        final child = <dynamic>[];
        _yamlListToList(child, value);
        result[key] = child;
      } else {
        result[key] = entry.value;
      }
    }
  }

  /// [yamlList] を通常の [List] へ再帰変換して [result] へ書き込む.
  ///
  /// Example:
  /// ```dart
  /// final out = <dynamic>[];
  /// YamlX._yamlListToList(out, yamlList);
  /// ```
  static void _yamlListToList(List<dynamic> result, yml.YamlList yamlList) {
    for (final value in yamlList.value) {
      if (value is yml.YamlMap) {
        final child = <String, dynamic>{};
        _yamlMapToMap(child, value);
        result.add(child);
      } else if (value is yml.YamlList) {
        final child = <dynamic>[];
        _yamlListToList(child, value);
        result.add(child);
      } else {
        result.add(value);
      }
    }
  }
}
