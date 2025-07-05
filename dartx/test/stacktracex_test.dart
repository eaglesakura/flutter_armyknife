import 'package:armyknife_dartx/src/stacktracex.dart';
import 'package:test/test.dart';

void main() {
  final currentFileName = StackTraceX.currentFileName();
  test('ファイル名を取得できる', () {
    final name = StackTraceX.currentFileName();
    expect(name, 'stacktracex_test.dart');
    expect(name, currentFileName);
  });
}
