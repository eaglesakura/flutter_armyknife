// ignore_for_file: avoid_print

import 'dart:async';

import 'package:async_notify2/async_notify2.dart';
import 'package:test/test.dart';

void main() {
  test('notify', () async {
    final notify = Notify();
    try {
      unawaited(() async {
        await Future<void>.delayed(const Duration(seconds: 1));
        print('notify');
        notify.notify();
        print('notify.done!');
      }());
      print('wait...');
      await notify.wait(); // wait 1sec.
      print('wait.done!');
    } finally {
      await notify.dispose();
    }
  });
}
