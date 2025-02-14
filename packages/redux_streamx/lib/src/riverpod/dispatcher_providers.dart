import 'package:redux_streamx/src/redux_dispatcher.dart';
import 'package:redux_streamx/src/redux_store.dart';
import 'package:riverpodx/riverpodx.dart';

@Deprecated('Use state_stream package')
final class DispatcherProviders {
  const DispatcherProviders._();

  /// Provider.autoDispose()を使ってStateを取得するProviderを生成する.
  static const autoDispose = _AutoDisposeProviders._();
}

@Deprecated('Use state_stream package')
final class _AutoDisposeProviders {
  const _AutoDisposeProviders._();

  /// [ReduxDispatcher] からStateを取得するProviderを生成する.
  /// Dispatcher自体の生成は別な [dispatcherProvider] に任されている.
  AutoDisposeProvider<T> state<T extends ReduxState>(
    AutoDisposeProvider<ReduxDispatcher<T>> dispatcherProvider,
  ) {
    return Provider.autoDispose<T>(
      (ref) {
        final dispatcher = ref.watch(dispatcherProvider);

        final subscribe = dispatcher.store.stream.listen((state) {
          ref.state = state;
        });
        ref.onDispose(subscribe.cancel);
        return dispatcher.store.state;
      },
      dependencies: [
        dispatcherProvider,
      ],
    );
  }
}
