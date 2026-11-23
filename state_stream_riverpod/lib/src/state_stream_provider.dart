import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';

/// [StateStream] からStateを取得するProviderを生成する.
final class StateStreamProvider {
  /// Provider.autoDispose()を使ってStateを取得するProviderを生成する.
  static const autoDispose = _AutoDisposeProvider._();

  /// 外部からの直接生成を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // StateStreamProvider.autoDispose 経由で利用する.
  /// final provider = StateStreamProvider.autoDispose.state(myStateStreamProvider);
  /// ```
  const StateStreamProvider._();
}

/// autoDispose向けの [StateStream] Provider生成口.
final class _AutoDisposeProvider {
  /// 外部からの直接生成を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // StateStreamProvider.autoDispose 経由で利用する.
  /// final provider = StateStreamProvider.autoDispose.state(myStateStreamProvider);
  /// ```
  const _AutoDisposeProvider._();

  /// [StateStream] からStateを取得するProviderを生成する.
  ///
  /// StateStream自体の生成は別な [stateStreamProvider] に任されている.
  ///
  /// Example:
  /// ```dart
  /// final counterState = StateStreamProvider.autoDispose.state(counterStreamProvider);
  /// ```
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
  ///
  /// Example:
  /// ```dart
  /// final labelState = StateStreamProvider.autoDispose.stateBy(
  ///   parentProvider,
  ///   (parent) => parent.labelStream,
  /// );
  /// ```
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
  /// [Ref] から監視対象の [StateStream] を解決する関数.
  final StateStream<T> Function(Ref ref) _getStateStream;

  /// [StateStream.stream] への購読.
  StreamSubscription? _subscription;

  /// [_getStateStream] で解決したStreamを [Notifier] に橋渡しする.
  ///
  /// Example:
  /// ```dart
  /// // StateStreamProvider.autoDispose.state 経由で生成される.
  /// final provider = StateStreamProvider.autoDispose.state(myStateStreamProvider);
  /// ```
  _StateStreamNotifier(this._getStateStream);

  /// [StateStream] の現在値を初期stateとし、以降の通知を反映する.
  ///
  /// Example:
  /// ```dart
  /// // Riverpod が Provider 解決時に呼び出す.
  /// final value = ref.watch(counterState);
  /// ```
  @override
  T build() {
    _subscription?.cancel();
    final stateStream = _getStateStream(ref);
    _subscription = stateStream.stream.listen((e) {
      if (ref.mounted) {
        state = e;
      }
    });

    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });
    return stateStream.state;
  }
}
