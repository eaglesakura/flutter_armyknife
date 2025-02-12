import 'package:flutter_test/flutter_test.dart';
import 'package:loggerx/loggerx.dart';
import 'package:time_machine/time_machine.dart';

final _log = Logger.file();

void main() {
  test('現在時刻取得', () {
    final now = Instant.now();
    final localDate = now.toDateTimeLocal();
    final utcDate = now.toDateTimeUtc();
    _log.i('now: $now');
    _log.i('localDate: $localDate');
    _log.i('utcDate: $utcDate');
  });
}
