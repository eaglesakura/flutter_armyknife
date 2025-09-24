import 'package:armyknife_streams/armyknife_streams.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:future_context2/src/future_context_request.dart';

/// English:
/// Automatically generates a Context or inherits from parent, and executes the specified processing.
///
/// Regardless of external Context input, a Context is always issued to [block].
///
/// 日本語:
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
  final withContextTimeout = contexts
      .whereType<WithContextTimeout>()
      .firstOrNull;

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

/// English:
/// Automatically generates a Context or inherits from parent, and executes the specified processing.
/// Results are processed as a Stream.
///
/// When receiving exceptions, yield* is not recommended.
///
/// 日本語:
/// Contextを自動生成もしくは親からの継承を行い、指定の処理を実行する.
/// 結果はStreamで処理される.
///
/// 例外を受け取る場合、 yield* は推奨されない.
@Deprecated('use withContext instead')
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

/// English: Specifies FutureContext.tag.
/// 日本語: FutureContext.tagを指定する.
class WithContextTag {
  /// English: Tag to specify.
  /// 日本語: 明示するタグ.
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

/// English: Specifies FutureContext.timeout.
/// 日本語: FutureContext.timeoutを指定する.
class WithContextTimeout {
  /// English: Timeout duration.
  /// 日本語: タイムアウト時間.
  final Duration duration;
  const WithContextTimeout(this.duration);

  @override
  int get hashCode => duration.hashCode;

  @override
  bool operator ==(covariant WithContextTimeout other) {
    if (identical(this, other)) {
      return true;
    }

    return other.duration == duration;
  }

  @override
  String toString() => 'WithContextTimeout(duration: $duration)';
}
