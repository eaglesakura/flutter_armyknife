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

  /// Yamlの特定pathから値を取得する
  static T require<T>(dynamic yaml, List<String> path) {
    final result = find<T>(yaml, path);
    if (result == null) {
      throw ArgumentError('Not found: ${path.join('.')}');
    }
    return result;
  }
}
