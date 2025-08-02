import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';

/// [StateStream] からStateを取得するProviderを生成する.
/// 互換性のために残されている.
@Deprecated('Use `StateStreamProvider` instead')
typedef StateStreamProviders = StateStreamProvider;

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
  AutoDisposeProvider<T> state<T>(
    AutoDisposeProvider<StateStream<T>> stateStreamProvider,
  ) {
    return Provider.autoDispose<T>(
      (ref) {
        final stateStream = ref.watch(stateStreamProvider);

        final subscribe = stateStream.stream.listen((state) {
          ref.state = state;
        });
        ref.onDispose(subscribe.cancel);
        return stateStream.state;
      },
      dependencies: [
        stateStreamProvider,
      ],
    );
  }

  /// [valueProvider] から[selector]で変換した [StateStream]`<T>`を取得し、
  /// [StateStream] からStateを取得するProviderを生成する.
  AutoDisposeProvider<T> stateBy<V, T>(
    AutoDisposeProvider<V> valueProvider,
    StateStream<T> Function(V value) selector,
  ) {
    return Provider.autoDispose<T>(
      (ref) {
        final stateStream = ref.watch(valueProvider.select(selector));
        final subscribe = stateStream.stream.listen((state) {
          ref.state = state;
        });
        ref.onDispose(subscribe.cancel);
        return stateStream.state;
      },
      dependencies: [
        valueProvider,
      ],
    );
  }
}
