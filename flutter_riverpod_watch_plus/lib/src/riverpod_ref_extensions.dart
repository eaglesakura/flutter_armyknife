import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/src/watch_value.dart';
import 'package:riverpod/misc.dart';

/// [Ref] 向けに値監視を拡張する.
extension RefWatchBy on Ref {
  /// 指定の値を監視する.
  ///
  /// Collectionの監視をサポートする.
  ///
  /// NOTE.
  /// Riverpodの仕様として、Collectionを監視すると、Collectionの参照比較が行われるため、
  /// 内容が同じでも再描画が発生する.
  /// この仕様を回避するために、中間オブジェクトを使用してCollectionの参照を管理する.
  ///
  /// Collection以外にも利用できるが、その場合は中間オブジェクトの生成負荷が発生することに留意する.
  ///
  /// [provider] 監視対象のProvider.
  /// [selector] [provider] の値から監視したい部分を取り出す関数.
  ///
  /// Example:
  /// ```dart
  /// final items = ref.watchBy(
  ///   stateProvider,
  ///   (state) => state.items,
  /// );
  /// ```
  T watchBy<P, T>(
    ProviderListenable<P> provider,
    T Function(P) selector,
  ) {
    final tmp = watch(
      provider.select((value) {
        final list = selector(value);
        return WatchValue(list);
      }),
    );
    return tmp.value as T;
  }
}
