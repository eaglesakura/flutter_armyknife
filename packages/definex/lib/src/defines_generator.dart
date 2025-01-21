import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:grinderx/grinderx.dart';
import 'package:mustache_template/mustache.dart';

/// --define で渡した値の定数を生成するジェネレータ.
class DefinesGenerator {
  final _keys = <String>{};

  DefinesGenerator();

  /// 定数を追加する.
  void addAll(Iterable<String> keys) => _keys.addAll(keys);

  /// defines.dartを生成する.
  void generate(
    File outputDartFile, {
    /// path/to/defines.mustache
    required File definesMustache,

    /// path/to/test.json
    required String pathToTestDefineJson,
  }) {
    final mustacheValues = {
      'relativePathToTestDefinesJson': pathToTestDefineJson,
      ..._compileMustacheValues(),
    };

    final template = Template(definesMustache.readAsStringSync());
    final renderString = template.renderString(mustacheValues);

    // ディレクトリを作成
    if (!outputDartFile.parent.existsSync()) {
      outputDartFile.parent.createSync(recursive: true);
    }
    outputDartFile.writeAsStringSync(renderString);
    context.dart('format', args: [
      outputDartFile.absolute.path,
    ]);
  }

  /// Mustacheテンプレート引数を生成する.
  Map<String, dynamic> _compileMustacheValues() {
    return <String, dynamic>{
      'keys': _keys.toList(),
    };
  }
}
