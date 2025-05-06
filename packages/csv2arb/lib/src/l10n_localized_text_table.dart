import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv2arb/src/localized_text.dart';
import 'package:dartx/dartx.dart';
import 'package:dartxx/dartxx.dart';
import 'package:grinder/grinder.dart';
import 'package:grinderx/grinderx.dart';
import 'package:path/path.dart' as path;

final _log = context.logger(tag: '$L10nLocalizedTextTable');

/// 1行目をkeyとしたKey-Valueソースからローカライズテキストを生成する.
typedef LocalizedTextFactory = LocalizedText Function(Map<String, String> row);

/// 多言語対応テキストを記述したCSVを読み込み、ローカライズテキストを生成する.
class L10nLocalizedTextTable {
  /// 登録されたローカライズテキスト一覧.
  final Map<String, LocalizedText> _localizedTexts = {};

  /// 対応言語一覧を取得する.
  List<String> get languages => _localizedTexts.entries
      .map((e) => e.value.text.keys)
      .flatten()
      .toSet()
      .sorted()
      .toList();

  /// 登録されたローカライズテキスト一覧を取得する.
  List<LocalizedText> get localizedTexts => _localizedTexts.entries
      .sortedBy((e) => e.key)
      .map((e) => e.value)
      .toList();

  /// CSVファイルを読み込み、ローカライズテキストを生成する.
  /// 複数回コールすることで、複数のCSVファイルを読み込むことができる.
  void addCsv({
    required File csvFile,
    required LocalizedTextFactory factory,
  }) {
    final codec = CsvCodec(
      eol: '\n',
    );
    final csv = csvFile.readAsStringSync();
    final header = codec.decoder.convert<dynamic>(csv).map((e) {
      return e.map((e) => e.toString()).mapIndexed((index, token) {
        return MapEntry(index, token);
      }).toMap();
    }).first;
    if (header.isEmpty) {
      throw ArgumentError('Empty CSV: ${csvFile.path}');
    }

    final rows = codec.decoder.convert<dynamic>(csv).skip(1).map((e) {
      final keyValues = e.mapIndexed((index, token) {
        return MapEntry(header[index]!, token.toString());
      }).toMap();
      return factory(keyValues);
    });

    for (final row in rows) {
      if (_localizedTexts.containsKey(row.id)) {
        throw ArgumentError('Duplicated ID: ${row.id}');
      }
      _localizedTexts[row.id] = row;
      _log.i('append: ${row.id}');
    }
  }

  /// arbファイルを生成する.
  Future generateArb(Directory outputDirectory) async {
    final templates = languages
        .map((lang) => MapEntry(lang, <String, dynamic>{
              '@@locale': lang,
            }))
        .toMap();

    for (final text in localizedTexts) {
      final metadata = <String, dynamic>{
        if (text.placeHolders.isNotEmpty)
          'placeholders': () {
            final placeHolders = <String, dynamic>{};
            for (final key in text.placeHolders) {
              placeHolders[key] = <String, String>{
                'type': 'String',
              };
            }
            return placeHolders;
          }(),
        if (text.description != null) 'description': text.description,
      };
      for (final lang in languages) {
        final tmp = templates[lang]!;
        tmp[text.id] = text.text[lang];
        // メタデータを追加する.
        if (metadata.isNotEmpty) {
          tmp['@${text.id}'] = metadata;
        }
      }
    }

    // arbファイルを保存
    final output = outputDirectory.absolute;
    if (!output.existsSync()) {
      output.createSync(recursive: true);
    }
    for (final tmp in templates.entries) {
      final lang = tmp.key;
      final data = tmp.value;
      final arbFile = File(path.join(output.path, 'intl_$lang.arb'));
      const encoder = JsonEncoder.withIndent('  ');
      arbFile.writeAsStringSync(encoder.convert(data));
      _log.i('Generated: ${arbFile.path}');
    }
  }

  /// ローカライズされたテキスト情報を取得する
  LocalizedText get(String id) {
    return _localizedTexts[id]!;
  }
}
