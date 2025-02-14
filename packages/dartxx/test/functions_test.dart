// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:test/test.dart';

void main() {
  test('nop', () async {
    final done1 = Completer();
    final done2 = Completer();
    final nopTask = nop();
    unawaited(() async {
      print('step1');
      await nop();
      print('step3');
      await nop();
      print('step5');
      done1.complete();
    }());
    unawaited(() async {
      print('stepA');
      await nop();
      print('stepB');
      await nop();
      print('stepC');
      done2.complete();
    }());
    print('step2');
    await nop();
    print('step4');
    await nopTask;
    print('step6');
    await done1.future;
    await done2.future;
    print('step7');
  });
}
