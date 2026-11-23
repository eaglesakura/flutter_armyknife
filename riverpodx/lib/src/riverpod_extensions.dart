import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

/// Hooksを使用してStreamを監視する.
///
/// Streamのデータは受信後に1フレーム遅れて処理される.
/// これはbuild()イベント中にUI操作が行われるとクラッシュするFlutter固有問題を回避するためである.
///
/// [newStream] 購読対象のStreamを返すファクトリ.
/// [onData] 受信データを処理するコールバック.
/// [keys] [useEffect] の依存キー。省略時は毎回再購読しない既定動作に従う.
///
/// Example:
/// ```dart
/// useEventStream(
///   () => eventBus.stream,
///   (event) async {
///     // UI更新など、build外で安全に行う処理
///   },
///   const [],
/// );
/// ```
void useEventStream<T>(
  Stream<T> Function() newStream,
  FutureOr Function(T) onData, [
  List<Object?>? keys,
]) {
  useEffect(() {
    final subscribe = newStream().listen((data) async {
      await Future.delayed(Duration.zero);
      await onData(data);
    });
    return subscribe.cancel;
  }, keys);
}
