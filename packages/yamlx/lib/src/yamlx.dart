import 'dart:io';

import 'package:dartxx/dartxx.dart';
import 'package:yaml/yaml.dart' as yml;

/// YamlのUtil関数群.
final class YamlX {
  const YamlX._();

  /// Yamlの特定pathから値を取得する
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

  /// シンプルなMap構造として読み込む
  static Map<String, dynamic> parse(File file) {
    final tmp = yml.loadYaml(file.readAsStringSync()) as yml.YamlMap;
    final data = <String, dynamic>{};
    _yamlMapToMap(data, tmp);
    return data;
  }

  /// 指定されたyamlファイルをマージして読み込む
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

  /// Yamlの特定pathから値を取得する
  static T require<T>(dynamic yaml, List<String> path) {
    final result = find<T>(yaml, path);
    if (result == null) {
      throw ArgumentError('Not found: ${path.join('.')}');
    }
    return result;
  }

  static void _yamlMapToMap(Map<String, dynamic> result, yml.YamlMap yamlMap) {
    for (final entry in yamlMap.entries) {
      if (entry.value is yml.YamlMap) {
        final child = <String, dynamic>{};
        _yamlMapToMap(child, entry.value as yml.YamlMap);
        result[entry.key.toString()] = child;
      } else {
        result[entry.key.toString()] = entry.value;
      }
    }
  }
}
