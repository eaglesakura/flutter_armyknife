import 'dart:async';

import 'package:future_context2/src/future_context_request.dart';
import 'package:future_context2/src/impl/future_context_impl.dart' as legacy;
import 'package:meta/meta.dart';

/// 非同期処理のキャンセル不可能な1ブロック処理.
///
/// ブロック完了後に復帰チェックが行われ、必要であればキャンセル等を行う.
typedef FutureSuspendBlock<T> = Future<T> Function(FutureContext context);

/// 非同期（Async）状態を管理する.
///
/// 目標はキャンセル可能な非同期処理のサポートである.
///
/// KotlinにおけるCoroutineContextやJobに相当する.
/// Dartには非同期処理のキャンセルや状態管理に相当する仕組みがないため、この機能にて代替する.
///
/// 開発者は [FutureContext.suspend] に関数を渡し、実行を行う.
/// [suspend] 実行前後に状態を確認し、必要であればキャンセル等の処理や中断を行う.
abstract class FutureContext {
  /// トップレベルの [FutureContext] を生成する.
  ///
  /// [tag] はログ識別用.
  /// 省略時はデバッグビルドでは呼び出し元のファイル・行から自動生成される.
  ///
  /// [request] はデバッグ用スタック深さなど生成時オプション.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContext(tag: 'load');
  /// await context.suspend((c) async => 1);
  /// await context.close();
  /// ```
  factory FutureContext({
    String? tag,
    FutureContextRequest request = const FutureContextRequest(),
  }) => legacy.FutureContextImpl(
    tag: tag,
    debugCallStackLevel: request.debugCallStackLevel + 1,
  );

  /// 指定した親Contextを持つ [FutureContext] を作成する.
  ///
  /// [parent] がキャンセルされると、この [FutureContext] もキャンセルされる.
  ///
  /// [tag] はログ識別用.
  /// [request] はデバッグ用スタック深さなど生成時オプション.
  ///
  /// Example:
  /// ```dart
  /// final parent = FutureContext();
  /// final child = FutureContext.child(parent, tag: 'child');
  /// await parent.close(); // child もキャンセル扱いになる
  /// ```
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

  /// 指定のContext一覧をグルーピングして [FutureContext] を作成する.
  ///
  /// [contexts] のいずれかがキャンセルされると、この [FutureContext] もキャンセルされる.
  ///
  /// [tag] はログ識別用.
  /// [request] はデバッグ用スタック深さなど生成時オプション.
  ///
  /// Example:
  /// ```dart
  /// final a = FutureContext();
  /// final b = FutureContext();
  /// final grouped = FutureContext.group([a, b], tag: 'group');
  /// await a.close(); // grouped もキャンセル扱いになる
  /// ```
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

  /// 処理が継続中かどうか.
  ///
  /// 親やグループ内のいずれかが非アクティブなら `false`.
  bool get isActive;

  /// 処理がキャンセル済みかどうか.
  ///
  /// 自身または親・グループ内のいずれかがキャンセルされていれば `true`.
  bool get isCanceled;

  /// キャンセル状態を購読するStream.
  ///
  /// キャンセル確定後はストリームが閉じる実装がありうる.
  Stream<bool> get isCanceledStream;

  /// Logging用Tag.
  String get tag;

  /// Futureをキャンセルする.
  ///
  /// すでにキャンセル済みの場合は何もしない.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContext();
  /// await context.close();
  /// ```
  Future<void> close();

  /// 指定時間Contextを停止させる.
  ///
  /// [duration] の待機中にキャンセルが発生した場合、速やかに処理は停止する.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContext();
  /// await context.delayed(const Duration(seconds: 1));
  /// ```
  Future<void> delayed(final Duration duration);

  /// 非同期処理の状態をチェックし、実行可能状態まで待機する.
  ///
  /// 実行不可能な状態である場合、[resume] 処理はロックを行うことを許容する.
  /// ただし、関連するContextが閉じられたら直ちにキャンセルが発生しなければならない.
  ///
  /// Example:
  /// ```dart
  /// // 実装側から呼び出し、実行可能になるまで待機する.
  /// await context.resume();
  /// ```
  @protected
  Future<void> resume();

  /// 非同期処理の特定1ブロックを実行する.
  ///
  /// [FutureContext] の実行最小単位として機能する.
  /// [suspend] 内部では実行開始時・終了時にそれぞれ状態チェックを行い、
  /// 必要であれば例外を投げる等の中断処理を行う.
  ///
  /// 開発者は可能な限り細切れに [suspend] に処理を分割することで、
  /// 処理の速やかな中断のサポートを受けることができる.
  ///
  /// [block] はキャンセル不可能な1ブロックとして実行される.
  ///
  /// 1コールのオーバーヘッドが大きいため、
  /// 内部でキャンセル処理が必要なほど長い場合に利用する.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContext();
  /// final value = await context.suspend((c) async {
  ///   await c.delayed(const Duration(milliseconds: 10));
  ///   return 42;
  /// });
  /// ```
  Future<T2> suspend<T2>(FutureSuspendBlock<T2> block);

  /// タイムアウト付きの非同期処理を開始する.
  ///
  /// [timeout] 経過後、[block] は [TimeoutException] が発生して終了する.
  /// [request] は子Context生成時のデバッグ用オプション.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContext();
  /// await context.withTimeout(
  ///   const Duration(seconds: 1),
  ///   (c) async => 'ok',
  /// );
  /// ```
  Future<T2> withTimeout<T2>(
    Duration timeout,
    FutureSuspendBlock<T2> block, {
    FutureContextRequest request = const FutureContextRequest(),
  });
}
