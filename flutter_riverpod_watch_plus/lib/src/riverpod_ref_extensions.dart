import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/src/watch_value.dart';

extension RefWatchBy on Ref {
  /// Watches the specified value.
  /// This extension function supports watching Collections.
  ///
  /// NOTE.
  /// Due to Riverpod's specification, when watching Collections, reference comparison is performed,
  /// causing re-rendering even when the content is the same.
  /// To avoid this specification, an intermediate object is used to manage Collection references.
  ///
  /// It can also be used for non-Collections, but note that intermediate object creation overhead occurs in that case.
  ///
  /// 指定の値を監視する.
  /// この拡張関数は、Collectionの監視をサポートする.
  ///
  /// 注意.
  /// Riverpodの仕様として、Collectionを監視すると、Collectionの参照比較が行われるため、
  /// 内容が同じでも再描画が発生する.
  /// この仕様を回避するために、中間オブジェクトを使用してCollectionの参照を管理する.
  ///
  /// Collection以外にも利用できるが、その場合は中間オブジェクトの生成負荷が発生することに留意する.
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
