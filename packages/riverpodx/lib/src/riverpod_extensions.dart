import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterx/flutterx.dart';

/// Hooksを使用してStreamを監視する.
///
/// Streamのデータは受診後に1フレーム遅れて処理される.
/// これはbuild()イベント中にUI操作が行われるとクラッシュするFlutter固有問題を回避するためである.
void useEventStream<T>(
  Stream<T> Function() newStream,
  void Function(T) onData, [
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
