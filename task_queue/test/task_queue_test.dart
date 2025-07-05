// ignore_for_file: avoid_print

import 'dart:math';

import 'package:armyknife_task_queue/armyknife_task_queue.dart';
import 'package:test/test.dart';

void main() {
  test('タスクを順次実行できる', () async {
    final queue = TaskQueue();
    var result = 0;

    final task1 = queue.queue(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      result++;
      return result;
    });
    final task2 = queue.queue(() async {
      await Future.delayed(const Duration(milliseconds: 200));
      result++;
      return result;
    });
    final task3 = queue.queue(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      result++;
      return result;
    });

    // 並列実行されず、順番に実行される
    expect(1, await task1);
    expect(2, await task2);
    expect(3, await task3);
  });

  test('順番を守って実行できる', () async {
    final rand = Random();
    final queue = TaskQueue();
    const loop = 10;

    final tasks = <Future<int>>[];
    for (var i = 0; i < loop; ++i) {
      tasks.add(
        queue.queue(() async {
          await Future.delayed(Duration(milliseconds: rand.nextInt(100)));
          print('task $i');
          return i;
        }),
      );
    }

    await Future.wait(tasks).then((values) {
      for (var i = 0; i < loop; ++i) {
        expect(i, values[i]);
      }
    });
  });
}
