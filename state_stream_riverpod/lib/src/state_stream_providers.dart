import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';

final class StateStreamProviders {
  /// Provider.autoDispose()を使ってStateを取得するProviderを生成する.
  static const autoDispose = _AutoDisposeProviders._();

  const StateStreamProviders._();
}

final class _AutoDisposeProviders {
  const _AutoDisposeProviders._();

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
}
