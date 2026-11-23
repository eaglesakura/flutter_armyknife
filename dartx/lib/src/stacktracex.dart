import 'package:armyknife_dartx/src/dartxx_functions.dart';

/// スタックトレースから呼び出し元情報を取り出すユーティリティ.
class StackTraceX {
  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // StackTraceX は静的メソッドのみ利用する
  /// ```
  const StackTraceX._();

  /// 呼び出し元のファイル名を取得する.
  ///
  /// [popLevel]はスタックトレースの深さを指定することができる.
  /// Webとそれ以外でスタック形式が異なるため、内部でオフセットを補正する.
  ///
  /// Example:
  /// ```dart
  /// final name = StackTraceX.currentFileName();
  /// final caller = StackTraceX.currentFileName(popLevel: 1);
  /// ```
  static String currentFileName({int popLevel = 0}) {
    final popLevel_ =
        () {
          if (kIsWebCompat) {
            return 2;
          } else {
            return 1;
          }
        }() +
        popLevel;

    // StackTraceの先頭からn番目のファイル・行を取得する
    final currentTrace = StackTrace.current.toString();
    final trace = currentTrace.split('\n')[popLevel_];
    var file = trace.replaceAll(r'\', '/').split('/').last;
    final split = file.split(':');
    if (kIsWebCompat) {
      file = split[0].replaceAll('.dart', '.dart:').replaceAll('::', ':');
    } else if (split.length >= 2) {
      file = '${split[0]}:${split[1]}';
    }
    final fileWithLine = file.replaceAll(')', '').replaceAll(' ', '');
    return fileWithLine.split(':').first;
  }
}
