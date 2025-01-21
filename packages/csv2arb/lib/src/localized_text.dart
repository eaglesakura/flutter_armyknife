import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grinderx/grinderx.dart';

part 'localized_text.freezed.dart';

/// ローカライズされた1つのテキストを表す.
@freezed
sealed class LocalizedText with _$LocalizedText {
  factory LocalizedText({
    /// 所属しているPackage.
    required DartPackage dartPackage,

    /// メッセージを一意に識別するためのID.
    required String id,

    /// 出力されるメッセージ.
    required Map<String, String> text,

    /// メッセージ引数.
    required List<String> placeHolders,

    /// メッセージの説明.
    String? description,
  }) = _LocalizedText;

  const LocalizedText._();

  /// {example}で囲われたブロックをPlaceholderとして取り出す.
  static List<String> parsePlaceholders(String text) {
    return RegExp('{.*?}').allMatches(text).map((e) {
      final group = e.group(0)!;
      return group.substring(1, group.length - 1);
    }).toList();
  }
}
