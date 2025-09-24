import 'dart:async';

import 'package:future_context2/src/future_context_request.dart';
import 'package:future_context2/src/impl/future_context_impl.dart' as legacy;
import 'package:meta/meta.dart';

/// English:
/// A single block of non-cancellable asynchronous processing.
/// After this block completes, FutureContext performs a recovery check and cancels if necessary.
///
/// 日本語:
/// 非同期処理のキャンセル不可能な1ブロック処理
/// このブロック完了後、FutureContextは復帰チェックを行い、必要であればキャンセル等を行う.
typedef FutureSuspendBlock<T> = Future<T> Function(FutureContext context);

/// English:
/// Manages asynchronous (Async) state.
/// The goal of FutureContext is to support cancellable asynchronous processing.
///
/// Equivalent to CoroutineContext or Job in Kotlin.
/// Since Dart doesn't have built-in mechanisms for asynchronous processing cancellation
/// or state management, this functionality provides an alternative.
///
/// Developers pass functions to FutureContext.suspend() for execution.
/// suspend() checks the FutureContext state before and after execution and performs
/// cancellation or interruption processing as needed.
///
/// 日本語:
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
  /// English: Creates a top-level FutureContext.
  /// 日本語: トップレベルのFutureContextを生成する.
  factory FutureContext({
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) => legacy.FutureContextImpl(
    tag: tag,
    debugCallStackLevel: request.debugCallStackLevel + 1,
  );

  /// English: Creates a FutureContext with the specified parent Context.
  /// When the parent Context is cancelled, this FutureContext is also cancelled.
  ///
  /// 日本語: 指定した親Contextを持つFutureContextを作成する.
  /// 親のContextがキャンセルされると、このFutureContextもキャンセルされる.
  factory FutureContext.child(
    FutureContext parent, {
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) {
    return legacy.FutureContextImpl.child(
      parent,
      tag: tag,
      debugCallStackLevel: request.debugCallStackLevel + 1,
    );
  }

  /// English: Creates a FutureContext by grouping the specified list of Contexts.
  /// When any of the Contexts is cancelled, this FutureContext is also cancelled.
  ///
  /// 日本語: 指定のContext一覧をグルーピングしてFutureContextを作成する.
  /// いずれかのContextがキャンセルされると、このFutureContextもキャンセルされる.
  factory FutureContext.group(
    Iterable<FutureContext> contexts, {
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) {
    return legacy.FutureContextImpl.group(
      contexts,
      tag: tag,
      debugCallStackLevel: request.debugCallStackLevel + 1,
    );
  }

  /// English: Returns true if processing is ongoing.
  /// 日本語: 処理が継続中の場合trueを返却する.
  bool get isActive;

  /// English: True if processing has been cancelled.
  /// 日本語: 処理がキャンセル済みの場合true.
  bool get isCanceled;

  /// English: Returns a Stream that handles cancellation state.
  /// 日本語: キャンセル状態をハンドリングするStreamを返却する.
  Stream<bool> get isCanceledStream;

  /// English: Tag for logging.
  /// 日本語: Logging用Tag.
  String get tag;

  /// English: Cancels the Future.
  /// Does nothing if already cancelled.
  ///
  /// 日本語: Futureをキャンセルする.
  /// すでにキャンセル済みの場合は何もしない.
  Future<void> close();

  /// English: Stops the Context for the specified duration.
  /// If cancellation occurs during delayed(), Context processing stops promptly.
  ///
  /// e.g.
  /// context.delayed(Duration(seconds: 1));
  ///
  /// 日本語: 指定時間Contextを停止させる.
  /// delayed()の最中にキャンセルが発生した場合、速やかにContext処理は停止する.
  Future<void> delayed(final Duration duration);

  /// English: Checks the state of asynchronous processing and waits until an executable state.
  /// If in a non-executable state, resume() processing is allowed to perform locking.
  /// However, cancellation must occur immediately when related Contexts are closed.
  ///
  /// 日本語: 非同期処理の状態をチェックし、実行可能状態まで待機する.
  /// 実行不可能な状態である場合、resume()処理はロックを行うことを許容する.
  /// ただし、関連するContextが閉じられたら直ちにキャンセルが発生しなければならない.
  @protected
  Future<void> resume();

  /// English: Executes a specific block of asynchronous processing.
  /// This functions as the minimum execution unit of FutureContext<T>.
  /// Inside suspend, AsyncContext state checks are performed at both start and end of execution,
  /// and interruption processing such as throwing exceptions is performed as needed.
  ///
  /// Developers can receive support for prompt interruption of processing by
  /// dividing processing into suspend() calls as much as possible.
  ///
  /// The suspend() function has a large overhead per call, so it should be used
  /// when the internal processing is long enough to require cancellation handling.
  ///
  /// 日本語: 非同期処理の特定1ブロックを実行する.
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

  /// English: Starts asynchronous processing with timeout.
  /// When timeout occurs, block() terminates with a [TimeoutException].
  ///
  /// 日本語: タイムアウト付きの非同期処理を開始する.
  /// タイムアウトが発生した場合、
  /// block()は [TimeoutException] が発生して終了する.
  Future<T2> withTimeout<T2>(
    Duration timeout,
    FutureSuspendBlock<T2> block, {
    FutureContextRequest request = const FutureContextRequest(),
  });
}
