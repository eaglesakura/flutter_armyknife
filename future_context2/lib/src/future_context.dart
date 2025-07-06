import 'dart:async';

import 'package:future_context2/src/future_context_request.dart';
import 'package:future_context2/src/impl/future_context_proxy.dart';
import 'package:future_context2/src/impl/legacy/future_context.dart' as legacy;
import 'package:meta/meta.dart';
import 'package:runtime_assert/runtime_assert.dart';

/// 非同期処理のキャンセル不可能な1ブロック処理
/// このブロック完了後、FutureContextは復帰チェックを行い、必要であればキャンセル等を行う.
typedef FutureSuspendBlock<T> = Future<T> Function(FutureContext context);

/// 非同期（Async）状態を管理する.
/// FutureContextの目標はキャンセル可能な非同期処理のサポートである.
///
/// KotlinにおけるCoroutineContextやJobに相当する.
/// Dartには非同期処理のキャンセルや状態管理に相当する仕組みがないため、
/// この機能にて代替する.
///
/// 開発者はFutureContext.suspend()に関数を渡し、実行を行う.
/// suspend()は実行前後にFutureContextの状態を確認し、必要であればキャンセル等の処理や中断を行う.
abstract class FutureContext {
  /// トップレベルのFutureContextを生成する.
  factory FutureContext({
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) => FutureContextProxy(
    legacy.FutureContext(
      tag: tag,
      debugCallStackLevel: request.debugCallStackLevel + 1,
    ),
  );

  /// 指定した親Contextを持つFutureContextを作成する.
  /// 親のContextがキャンセルされると、このFutureContextもキャンセルされる.
  factory FutureContext.child(
    FutureContext parent, {
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) {
    final impl = parent.queryInterface<legacy.FutureContext>();
    if (impl == null) {
      throw IllegalArgumentException('Unsupported Parent');
    }

    return FutureContextProxy(
      legacy.FutureContext.child(
        impl,
        tag: tag,
        debugCallStackLevel: request.debugCallStackLevel + 1,
      ),
    );
  }

  /// 指定のContext一覧をグルーピングしてFutureContextを作成する.
  /// いずれかのContextがキャンセルされると、このFutureContextもキャンセルされる.
  factory FutureContext.group(
    Iterable<FutureContext> contexts, {
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) {
    final implList = contexts.map((e) {
      final impl = e.queryInterface<legacy.FutureContext>();
      if (impl == null) {
        throw IllegalArgumentException('Unsupported Parent');
      }
      return impl;
    }).toList();

    return FutureContextProxy(
      legacy.FutureContext.group(
        implList,
        tag: tag,
        debugCallStackLevel: request.debugCallStackLevel + 1,
      ),
    );
  }

  /// 処理が継続中の場合trueを返却する.
  bool get isActive;

  /// 処理がキャンセル済みの場合true.
  bool get isCanceled;

  /// キャンセル状態をハンドリングするStreamを返却する.
  Stream<bool> get isCanceledStream;

  /// Futureをキャンセルする.
  /// すでにキャンセル済みの場合は何もしない.
  Future close();

  /// 指定時間Contextを停止させる.
  /// delayed()の最中にキャンセルが発生した場合、速やかにContext処理は停止する.
  ///
  /// e.g.
  /// context.delayed(Duration(seconds: 1));
  Future delayed(final Duration duration);

  /// 指定のインターフェースを検索する.
  /// 内部実装の検索等に使用する.
  @protected
  T? queryInterface<T>();

  /// 非同期処理の特定1ブロックを実行する.
  /// これはFutureContext<"T">の実行最小単位として機能する.
  /// suspend内部では実行開始時・終了時にそれぞれAsyncContextのステートチェックを行い、
  /// 必要であれば例外を投げる等の中断処理を行う.
  ///
  /// 開発者は可能な限り細切れに suspend() に処理を分割することで、
  /// 処理の速やかな中断のサポートを受けることができる.
  ///
  /// suspend()関数は1コールのオーバーヘッドが大きいため、
  /// 内部でキャンセル処理が必要なほど長い場合に利用する.
  Future<T2> suspend<T2>(FutureSuspendBlock<T2> block);

  /// タイムアウト付きの非同期処理を開始する.
  ///
  /// タイムアウトが発生した場合、
  /// block()は [TimeoutException] が発生して終了する.
  Future<T2> withTimeout<T2>(
    Duration timeout,
    FutureSuspendBlock<T2> block, {
    FutureContextRequest request = const FutureContextRequest(),
  });
}
