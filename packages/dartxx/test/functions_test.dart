// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:test/test.dart';

void main() {
  test('nop', () async {
    final done = Completer();
    final nopTask = nop();
    unawaited(() async {
      print('step1');
      await nop();
      print('step3');
      await nop();
      print('step5');
      done.complete();
    }());
    print('step2');
    await nop();
    print('step4');
    await nopTask;
    print('step6');
    await done.future;
    print('step7');
  });
}
