import 'package:armyknife_streams/armyknife_streams.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:future_context2/src/future_context_request.dart';

/// Contextを自動生成もしくは親からの継承を行い、指定の処理を実行する.
///
/// 外部からのContext入力にかかわらず、[block] には必ずContextが発行される.
///
/// [contexts] には [FutureContext]・[FutureContextRequest]・[WithContextTag]・[WithContextTimeout] を混在できる.
/// `Iterable` をネストしたまま渡すと [ArgumentError] になる.
///
/// 新規生成やグループ化で作ったContextは、処理終了後に自動で [FutureContext.close] される.
/// 単一の既存Contextを渡した場合は閉じない.
///
/// Example:
/// ```dart
/// final result = await withContext(
///   [const WithContextTag('load')],
///   (context) async => 1,
/// );
/// ```
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

/// Contextを自動生成もしくは親からの継承を行い、指定の処理を実行する.
///
/// 結果はStreamで処理される.
///
/// 例外を受け取る場合、 yield* は推奨されない.
///
/// [contexts] と [block] の扱いは [withContext] と同様.
///
/// Example:
/// ```dart
/// final stream = withContextStream(
///   [],
///   (context) async* {
///     yield 1;
///   },
/// );
/// ```
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

/// [FutureContext.tag] を指定する.
///
/// [withContext] の引数リストに混ぜて渡す.
class WithContextTag {
  /// 明示するタグ.
  ///
  /// `null` の場合はデフォルトタグ生成に任せる.
  final String? tag;

  /// [tag] 付きの指定オブジェクトを生成する.
  ///
  /// Example:
  /// ```dart
  /// await withContext(
  ///   [const WithContextTag('job')],
  ///   (context) async {},
  /// );
  /// ```
  const WithContextTag(this.tag);

  /// [tag] に基づくハッシュ値.
  @override
  int get hashCode => tag.hashCode;

  /// 同一 [tag] なら等価とみなす.
  ///
  /// [other] が同じ [tag] を持つときのみ `true`.
  ///
  /// Example:
  /// ```dart
  /// assert(const WithContextTag('a') == const WithContextTag('a'));
  /// ```
  @override
  bool operator ==(covariant WithContextTag other) {
    if (identical(this, other)) {
      return true;
    }

    return other.tag == tag;
  }

  /// デバッグ表示用の文字列表現.
  ///
  /// Example:
  /// ```dart
  /// print(const WithContextTag('a')); // WithContextTag(tag: a)
  /// ```
  @override
  String toString() => 'WithContextTag(tag: $tag)';
}

/// [FutureContext.withTimeout] 相当のタイムアウトを指定する.
///
/// [withContext] の引数リストに混ぜて渡す.
class WithContextTimeout {
  /// タイムアウト時間.
  final Duration duration;

  /// [duration] 付きの指定オブジェクトを生成する.
  ///
  /// Example:
  /// ```dart
  /// await withContext(
  ///   [const WithContextTimeout(Duration(seconds: 1))],
  ///   (context) async => 'ok',
  /// );
  /// ```
  const WithContextTimeout(this.duration);

  /// [duration] に基づくハッシュ値.
  @override
  int get hashCode => duration.hashCode;

  /// 同一 [duration] なら等価とみなす.
  ///
  /// [other] が同じ [duration] を持つときのみ `true`.
  ///
  /// Example:
  /// ```dart
  /// assert(
  ///   const WithContextTimeout(Duration(seconds: 1)) ==
  ///       const WithContextTimeout(Duration(seconds: 1)),
  /// );
  /// ```
  @override
  bool operator ==(covariant WithContextTimeout other) {
    if (identical(this, other)) {
      return true;
    }

    return other.duration == duration;
  }

  /// デバッグ表示用の文字列表現.
  ///
  /// Example:
  /// ```dart
  /// print(const WithContextTimeout(Duration(seconds: 1)));
  /// ```
  @override
  String toString() => 'WithContextTimeout(duration: $duration)';
}
