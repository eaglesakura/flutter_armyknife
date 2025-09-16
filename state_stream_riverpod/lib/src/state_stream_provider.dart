import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';

/// [StateStream] からStateを取得するProviderを生成する.
final class StateStreamProvider {
  /// Provider.autoDispose()を使ってStateを取得するProviderを生成する.
  static const autoDispose = _AutoDisposeProvider._();

  const StateStreamProvider._();
}

final class _AutoDisposeProvider {
  const _AutoDisposeProvider._();

  /// [StateStream] からStateを取得するProviderを生成する.
  /// StateStream自体の生成は別な [stateStreamProvider] に任されている.
  NotifierProvider<Notifier<T>, T> state<T>(
    Provider<StateStream<T>> stateStreamProvider,
  ) {
    return NotifierProvider.autoDispose(
      () {
        final result = _StateStreamNotifier((ref) {
          return ref.watch(stateStreamProvider);
        });
        return result;
      },
      dependencies: [
        stateStreamProvider,
      ],
    );
  }

  /// [valueProvider] から[selector]で変換した [StateStream]`<T>`を取得し、
  /// [StateStream] からStateを取得するProviderを生成する.
  NotifierProvider<Notifier<T>, T> stateBy<V, T>(
    Provider<V> valueProvider,
    StateStream<T> Function(V value) selector,
  ) {
    return NotifierProvider.autoDispose(
      () {
        final result = _StateStreamNotifier((ref) {
          return ref.watch(valueProvider.select(selector));
        });
        return result;
      },
      dependencies: [
        valueProvider,
      ],
    );
  }
}

/// [StateStream] と [Notifier] を連携させるためのインターフェース.
///
/// NOTE.
/// Riverpod 3.0以降、Refの直接的state更新が行えなくなったため、
/// [Notifier]を経由することで連携を行う.
/// https://riverpod.dev/docs/migration/from_state_notifier
class _StateStreamNotifier<T> extends Notifier<T> {
  final StateStream<T> Function(Ref ref) _getStateStream;

  StreamSubscription? _subscription;

  _StateStreamNotifier(this._getStateStream);

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  T build() {
    _subscription?.cancel();
    final stateStream = _getStateStream(ref);
    _subscription = stateStream.stream.listen((e) {
      if (!ref.mounted) {
        return;
      }
      state = e;
    });
    return stateStream.state;
  }
}
