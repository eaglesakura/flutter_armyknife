import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

void main() {
  group('StateStreamProvider.autoDispose.state', () {
    test('StateStreamの初期値をProvider経由で取得できる', () {
      final subject = BehaviorSubject.seeded(42);
      addTearDown(subject.close);

      final stateStreamProvider = Provider<StateStream<int>>((ref) {
        return StateStream.fromBehaviorSubject(subject);
      });
      final stateProvider = StateStreamProvider.autoDispose.state(
        stateStreamProvider,
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(stateProvider), 42);
    });

    test('BehaviorSubjectに値を追加するとProviderのstateが更新される', () async {
      final subject = BehaviorSubject.seeded(0);
      addTearDown(subject.close);

      final stateStreamProvider = Provider<StateStream<int>>((ref) {
        return StateStream.fromBehaviorSubject(subject);
      });
      final stateProvider = StateStreamProvider.autoDispose.state(
        stateStreamProvider,
      );

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final values = <int>[];
      container.listen(stateProvider, (prev, next) {
        values.add(next);
      });

      expect(container.read(stateProvider), 0);

      subject.add(10);
      await Future.microtask(() {});
      expect(container.read(stateProvider), 10);

      subject.add(20);
      await Future.microtask(() {});
      expect(container.read(stateProvider), 20);

      expect(values, contains(10));
      expect(values, contains(20));
    });

    test('ProviderContainer.dispose後にStreamSubscriptionがキャンセルされる', () {
      final subject = BehaviorSubject.seeded(0);
      addTearDown(subject.close);

      final stateStreamProvider = Provider<StateStream<int>>((ref) {
        return StateStream.fromBehaviorSubject(subject);
      });
      final stateProvider = StateStreamProvider.autoDispose.state(
        stateStreamProvider,
      );

      final container = ProviderContainer();

      container.listen(stateProvider, (prev, next) {});
      expect(subject.hasListener, isTrue);

      container.dispose();
      expect(subject.hasListener, isFalse);
    });

    test('dispose後にStreamへ値を追加してもエラーにならない', () async {
      final subject = BehaviorSubject.seeded(0);
      addTearDown(subject.close);

      final stateStreamProvider = Provider<StateStream<int>>((ref) {
        return StateStream.fromBehaviorSubject(subject);
      });
      final stateProvider = StateStreamProvider.autoDispose.state(
        stateStreamProvider,
      );

      final container = ProviderContainer();

      container.listen(stateProvider, (prev, next) {});
      container.dispose();

      expect(() => subject.add(99), returnsNormally);
    });
  });

  group('StateStreamProvider.autoDispose.stateBy', () {
    test('dispose時にStreamSubscriptionがキャンセルされる', () {
      final subject = BehaviorSubject.seeded(0);
      addTearDown(subject.close);

      final stateStream = StateStream.fromBehaviorSubject(subject);
      final holder = _StateStreamHolder(stateStream);

      final holderProvider = Provider<_StateStreamHolder>((ref) => holder);
      final stateProvider = StateStreamProvider.autoDispose
          .stateBy<_StateStreamHolder, int>(
            holderProvider,
            (h) => h.stateStream,
          );

      final container = ProviderContainer();

      container.listen(stateProvider, (prev, next) {});
      expect(subject.hasListener, isTrue);

      container.dispose();
      expect(subject.hasListener, isFalse);
    });
  });
}

class _StateStreamHolder {
  final StateStream<int> stateStream;

  _StateStreamHolder(this.stateStream);
}
