import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:future_context2/future_context2.dart';

/// Widgetのライフサイクルと [FutureContext] を紐づける.
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
