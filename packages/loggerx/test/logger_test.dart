import 'package:loggerx/loggerx.dart';
import 'package:test/test.dart';

void main() {
  group('ログ出力', () {
    test('Logger', () {
      final logger = Logger.tag('test');
      logger.i('info');
      logger.d('debug');
      logger.e('error');
      logger.w('warning');
    });
    test('Logger.of', () {
      final logger = Logger.of(String);
      logger.i('info');
      logger.d('debug');
      logger.e('error');
      logger.w('warning');
    });
  });
}
