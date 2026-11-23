import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:future_context2/future_context2.dart';

/// Widgetのライフサイクルと [FutureContext] を紐づける.
///
/// ライフサイクル終了時に [FutureContext.close] を呼ぶ.
///
/// [tag] は生成するFutureContextのログ識別用.
/// [keys] が変わると新しい [FutureContext] が生成され、旧インスタンスは閉じられる.
///
/// Example:
/// ```dart
/// class Example extends HookWidget {
///   @override
///   Widget build(BuildContext context) {
///     final futureContext = useFutureContext(tag: 'screen');
///     return const SizedBox.shrink();
///   }
/// }
/// ```
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
