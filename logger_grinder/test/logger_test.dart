import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:armyknife_logger_grinder/armyknife_logger_grinder.dart';
import 'package:test/test.dart';

void main() {
  setUp(() async {
    GrinderLogger.inject();
  });
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
