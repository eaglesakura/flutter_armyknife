import 'package:armyknife_dartx/src/dartxx_functions.dart';

class StackTraceX {
  const StackTraceX._();

  /// この関数を呼び出しているファイル名を取得する.
  ///
  /// [popLevel] はスタックトレースの深さを指定することができる.
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
