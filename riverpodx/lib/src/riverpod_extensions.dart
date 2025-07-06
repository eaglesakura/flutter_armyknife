import 'dart:async';

import 'package:armyknife_flutterx/armyknife_flutterx.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:future_context2/future_context2.dart';

/// Hooksを使用してStreamを監視する.
///
/// Streamのデータは受診後に1フレーム遅れて処理される.
/// これはbuild()イベント中にUI操作が行われるとクラッシュするFlutter固有問題を回避するためである.
void useEventStream<T>(
  Stream<T> Function() newStream,
  FutureOr Function(T) onData, [
  List<Object?>? keys,
]) {
  useEffect(() {
    final subscribe = newStream().listen((data) async {
      await vsync();
      onData(data);
    });
    return subscribe.cancel;
  }, keys);
}

/// WidgetのライフサイクルとFutureContextを紐づける.
///
/// ライフサイクル終了時にFutureContextを閉じる.
FutureContext useFutureContext({
  String? tag,
  List<Object?>? keys,
}) {
  final context = useMemoized(
    () => FutureContext(tag: tag),
    keys ?? [],
  );
  useEffect(
    () => () {
      context.close();
    },
    [context],
  );
  return context;
}
