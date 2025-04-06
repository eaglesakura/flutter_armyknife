import 'dart:async';

import 'package:dartxx/dartxx.dart';
import 'package:rxdart/rxdart.dart';

part 'streams.stream_emitter.dart';

/// Stream操作関数の糖衣構文
///
/// port:
/// https://github.com/vivitainc/flutter_armyknife_stdlib/blob/main/lib/src/streams.dart
final class Streams {
  Streams._();

  /// tupleへの型指定を省略してStreamのcombineを行う
  static CombineLatestStream<dynamic, (T1, T2)> combineLatest2<T1, T2>(
    Stream<T1> a,
    Stream<T2> b,
  ) {
    return CombineLatestStream.combine2(
      a,
      b,
      (a, b) => (a, b),
    );
  }

  /// tupleへの型指定を省略してStreamのcombineを行う
  static CombineLatestStream<dynamic, (T1, T2, T3)> combineLatest3<T1, T2, T3>(
    Stream<T1> a,
    Stream<T2> b,
    Stream<T3> c,
  ) {
    return CombineLatestStream.combine3(
      a,
      b,
      c,
      (a, b, c) => (a, b, c),
    );
  }

  /// tupleへの型指定を省略してStreamのcombineを行う
  static CombineLatestStream<dynamic, (T1, T2, T3, T4)>
      combineLatest4<T1, T2, T3, T4>(
    Stream<T1> a,
    Stream<T2> b,
    Stream<T3> c,
    Stream<T4> d,
  ) {
    return CombineLatestStream.combine4(
      a,
      b,
      c,
      d,
      (a, b, c, d) => (a, b, c, d),
    );
  }

  /// 生成型のStreamを生成する.
  ///
  /// 生成された [Subject] に対してメッセージを投げることで、別なメソッドからstreamを発生させることができる.
  /// [block] 内部で発生した例外は呼び出し側に例外として再送される.
  /// [block] が完了したら自動的にStreamは閉じられる.
  static Stream<T> generate<T>(
    Future Function(StreamEmitter<T> emitter) block,
  ) {
    var launched = false;
    late final Subject<T> subject;
    subject = PublishSubject(onListen: () async {
      if (launched) {
        return;
      }
      launched = true;
      try {
        await block(StreamEmitter._(subject));
        // ignore: avoid_catches_without_on_clauses
      } catch (e, stackTrace) {
        subject.addError(e, stackTrace);
      } finally {
        await subject.close();
      }
    });
    return subject.stream;
  }

  /// [Future] をNull通知可能なStreamに変換する.
  ///
  /// 最初にnullを通知し、その後に[Future]の結果を通知する.
  /// 内部では [Stream.distinct] を使用して、同一の通知を抑制する.
  static Stream<T?> fromFutureNullable<T>(Future<T> future) {
    return ConcatStream([
      Stream.value(null),
      Stream.fromFuture(future),
    ]).distinct();
  }
}
