import 'package:armyknife_logger/armyknife_logger.dart';
import 'package:armyknife_logger_flutter/armyknife_logger_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    FlutterLogger.inject();
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
