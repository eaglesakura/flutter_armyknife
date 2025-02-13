import 'package:flutter_test/flutter_test.dart';
import 'package:task_queue/task_queue.dart';

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
}
