import 'package:future_contextx/src/future_context.dart';
import 'package:future_contextx/src/future_context_request.dart';
import 'package:streamx/streamx.dart';

/// Contextを自動生成もしくは親からの継承を行い、指定の処理を実行する.
///
/// 外部からのContext入力にかかわらず、[block] には必ずContextが発行される.
Future<T> withContext<T>(
  List contexts,
  Future<T> Function(FutureContext context) block,
) async {
  late final FutureContext context;
  final contextRequest =
      contexts.whereType<FutureContextRequest>().firstOrNull ??
          const FutureContextRequest(
            debugCallStackLevel: 1,
          );
  final withContextTag = contexts.whereType<WithContextTag>().firstOrNull;
  final withContextTimeout =
      contexts.whereType<WithContextTimeout>().firstOrNull;

  // Iterableが含まれる場合はunwrapを促す
  if (contexts.any((element) => element is Iterable)) {
    throw ArgumentError('contexts must be unwrapped');
  }

  var closeContext = false;
  if (contexts.isNotEmpty) {
    final futureContextList = contexts.whereType<FutureContext>().toList();
    if (futureContextList.length == 1) {
      // 単一のContextの場合はそのまま利用する.
      context = futureContextList.first;
    } else {
      // 複数のContextがある場合はグループ化する.
      context = FutureContext.group(
        futureContextList,
        tag: withContextTag?.tag,
        request: contextRequest,
      );
      closeContext = true;
    }
  } else {
    // Contextが与えられないため、新規に生成する.
    context = FutureContext(
      tag: withContextTag?.tag,
      request: contextRequest,
    );
    closeContext = true;
  }

  try {
    if (withContextTimeout != null) {
      return await context.withTimeout(
        withContextTimeout.duration,
        (newContext) => block(newContext),
      );
    } else {
      return await context.suspend(
        (newContext) => block(newContext),
      );
    }
  } finally {
    if (closeContext) {
      await context.close();
    }
  }
}

/// Contextを自動生成もしくは親からの継承を行い、指定の処理を実行する.
/// 結果はStreamで処理される.
///
/// 例外を受け取る場合、 yield* は推奨されない.
/// yield*を使用する場合、例外が発生した場合、その例外はStreamの外に出てしまうため、
Stream<T> withContextStream<T>(
  List contexts,
  Stream<T> Function(FutureContext context) block,
) {
  return Streams.generate<T>((emitter) async {
    await withContext(
      contexts,
      (context) async {
        await for (final value in block(context)) {
          emitter.value = value;
        }
      },
    );
  });
}

/// FutureContext.tagを指定する.
class WithContextTag {
  /// 明示するタグ.
  final String? tag;

  const WithContextTag(this.tag);

  @override
  int get hashCode => tag.hashCode;

  @override
  bool operator ==(covariant WithContextTag other) {
    if (identical(this, other)) {
      return true;
    }

    return other.tag == tag;
  }

  @override
  String toString() => 'WithContextTag(tag: $tag)';
}

/// FutureContext.timeoutを指定する.
class WithContextTimeout {
  final Duration duration;
  const WithContextTimeout(this.duration);

  @override
  String toString() => 'WithContextTimeout(duration: $duration)';

  @override
  bool operator ==(covariant WithContextTimeout other) {
    if (identical(this, other)) {
      return true;
    }

    return other.duration == duration;
  }

  @override
  int get hashCode => duration.hashCode;
}
