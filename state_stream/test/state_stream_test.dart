import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_stream/src/mutable_state_stream.dart';

import 'test_state.dart';

void main() {
  test('初期化と終了', () async {
    var onCloseCall = false;
    final stream = MutableStateStream(
      const TestState(
        integer: 1,
      ),
      onClose: (state) async {
        onCloseCall = true;
      },
    );
    expect(stream.isClosed, isFalse);
    expect(stream.isNotClosed, isTrue);

    expect(stream.state.integer, 1);
    await stream.close();
    expect(stream.isClosed, isTrue);
    expect(stream.isNotClosed, isFalse);
    expect(onCloseCall, isTrue);
  });

  test('状態が更新される', () async {
    final stream = MutableStateStream(
      const TestState(
        integer: 1,
      ),
    );
    await stream.updateWithLock(
      (currentState, emitter) async {
        await emitter.emit(
          currentState.copyWith(
            integer: currentState.integer + 1,
          ),
        );
      },
    );
    expect(stream.state.integer, 2);
    await stream.close();
    expect(stream.isClosed, isTrue);
    expect(stream.isNotClosed, isFalse);
  });

  test('通知が行われる', () async {
    final stream = MutableStateStream(
      const TestState(
        integer: 1,
      ),
    );
    final states = <TestState>[];
    final subscription = stream.stream.listen(states.add);
    await stream.updateWithLock(
      (currentState, emitter) async {
        await emitter.emit(
          currentState.copyWith(
            integer: currentState.integer + 1,
          ),
        );
      },
    );
    await stream.updateWithLock(
      (currentState, emitter) async {
        await emitter.emit(
          currentState.copyWith(
            integer: currentState.integer + 1,
          ),
        );
      },
    );
    expect(states, hasLength(3));
    expect(states[0].integer, 1);
    expect(states[1].integer, 2);
    expect(states[2].integer, 3);
    await subscription.cancel();
    await stream.close();
  });

  test('ロック中の状態を取得できる', () async {
    final stream = MutableStateStream(
      const TestState(
        integer: 1,
      ),
    );

    // ロックを実行する
    expect(stream.isLocking, isFalse);
    final lockTask = stream.updateWithLock(
      (currentState, emitter) async {
        await nop();
        // 今はLock中である
        expect(stream.isLocking, isTrue);
      },
    );
    // lockタスクの中が実行中なので、ロック中である.
    expect(stream.isLocking, isTrue);
    await lockTask;

    // lockタスクが終了したので、ロック中ではない.
    expect(stream.isLocking, isFalse);

    // すでに閉じているので、ロック中ではない.
    await stream.close();
    expect(stream.isLocking, isFalse);
  });
}
