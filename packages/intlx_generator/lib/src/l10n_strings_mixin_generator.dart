import 'dart:io';

import 'package:csv2arb/csv2arb.dart';
import 'package:grinder/grinder.dart';
import 'package:grinderx/grinderx.dart';
import 'package:mustache_template/mustache.dart';

/// L10nStringsMixinを生成する.
/// 各packageごとに生成することで、packageごとのローカライズテキストを管理する.
class L10nStringsMixinGenerator {
  /// L10nStringsMixinを生成する.
  /// 各packageごとに生成することで、packageごとのローカライズテキストを管理する.
  Future generate(
    File outputDartFile, {

    /// path/to/l10n_strings_mixin.mustache
    required File l10nStringsMixinMustache,

    /// 出力するクラス名
    String className = 'L10nStringsMixin',

    /// ローカライズテキスト一覧.
    required List<LocalizedText> localizedTexts,
  }) async {
    final mustacheValues = {
      'className': className,
      'localizeStrings': localizedTexts
          .map(
            (e) => <String, dynamic>{
              'id': e.id,
              'placeholders': e.placeHolders,
              'hasPlaceholders': e.placeHolders.isNotEmpty,
            },
          )
          .toList(),
    };

    final template = Template(l10nStringsMixinMustache.readAsStringSync());
    final renderString = template.renderString(mustacheValues);

    final outputDirectory = outputDartFile.parent;
    if (!outputDirectory.existsSync()) {
      outputDirectory.createSync(recursive: true);
    }
    outputDartFile.writeAsStringSync(renderString);
    await context.dart('format', args: [outputDartFile.path]);
  }
}
