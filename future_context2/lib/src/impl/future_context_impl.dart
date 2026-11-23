import 'dart:async';

import 'package:async_notify2/async_notify2.dart';
import 'package:flutter/foundation.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:future_context2/src/future_context_controller.dart';
import 'package:future_context2/src/future_context_request.dart';
import 'package:rxdart/rxdart.dart';

/// port from https://github.com/vivitainc/flutter_future_context
/// 非同期（Async）状態を管理する.
///
/// 目標はキャンセル可能な非同期処理のサポートである.
///
/// 処理終了後、必ずしも [close] をコールする必要はない（メモリリークはしない）が、
/// 設計上は [close] をコールすることを推奨する.
///
/// 開発者は [FutureContext.suspend] に関数を渡し、実行を行う.
/// [suspend] 実行前後に状態を確認し、必要であればキャンセル等の処理や中断を行う.
///
/// NOTE. 2021-05
/// Flutter 2.2(Dart 2.12)現在、言語仕様としてKotlinのSuspend関数のような状態管理を行えない.
/// そのため、開発者側で適度にブロックを区切って実行を行えるようサポートする.
///
/// KotlinにはCoroutineDispatcherのようなさらに上位（周辺）の仕組みがあるが、
/// 目的に対してオーバースペックであるため実装を見送る.
///
/// 処理が冗長になることと、Dart標準からかけ離れていくリスクがあるため、
/// 使用箇所については慎重に検討が必要.
@internal
class FutureContextImpl implements FutureContext {
  /// 全体制御用コントローラ.
  final FutureContextController _controller = FutureContextController.instance;

  /// 親Context.
  ///
  /// 空集合ならトップレベルContextとして振る舞う.
  final Set<FutureContext> _group;

  /// 現在の状態.
  var _state = _ContextState.active;

  /// キャンセル識別用タグ.
  @override
  final String tag;

  /// 空の [FutureContext] を作成する.
  ///
  /// [tag] 省略時はデバッグビルドで呼び出し元のファイル・行から自動生成する.
  /// [debugCallStackLevel] は自動タグ生成時のStackTrace取得位置をずらす.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContextImpl(tag: 'root');
  /// await context.close();
  /// ```
  FutureContextImpl({
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: const {},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = const {};

  /// 指定した親Contextを持つ [FutureContext] を作成する.
  ///
  /// [parent] がキャンセルされると、このContextもキャンセル扱いになる.
  /// [tag] と [debugCallStackLevel] の扱いは [FutureContextImpl.new] と同様.
  ///
  /// Example:
  /// ```dart
  /// final parent = FutureContextImpl();
  /// final child = FutureContextImpl.child(parent, tag: 'child');
  /// ```
  FutureContextImpl.child(
    FutureContext parent, {
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: {parent},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = {parent};

  /// 指定した複数の親Contextを持つ [FutureContext] を作成する.
  ///
  /// [group] のいずれかがキャンセルされると、このContextもキャンセル扱いになる.
  /// [tag] と [debugCallStackLevel] の扱いは [FutureContextImpl.new] と同様.
  ///
  /// Example:
  /// ```dart
  /// final a = FutureContextImpl();
  /// final b = FutureContextImpl();
  /// final grouped = FutureContextImpl.group([a, b], tag: 'group');
  /// ```
  FutureContextImpl.group(
    Iterable<FutureContext> group, {
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: {...group},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = {...group};

  /// 処理が継続中かどうか.
  ///
  /// 一つでも非アクティブなものがあれば、このContextも非アクティブ.
  @override
  bool get isActive {
    // 一つでも非アクティブなものがあれば、このContextも非アクティブ.
    for (final c in _group) {
      if (!c.isActive) {
        return false;
      }
    }
    return _state == _ContextState.active;
  }

  /// 処理がキャンセル済みかどうか.
  ///
  /// 自身または親・グループ内のいずれかがキャンセルされていれば `true`.
  @override
  bool get isCanceled {
    // 軽量処理を先行して呼び出す
    if (_state == _ContextState.canceled) {
      return true;
    }

    // 一つでもキャンセルされていたら、このContextもキャンセルされている.
    for (final c in _group) {
      if (c.isCanceled) {
        return true;
      }
    }
    return false;
  }

  /// キャンセル状態をハンドリングするStream.
  ///
  /// 内部状態を [_stateStream] 経由で購読し、キャンセル可否へ写像する.
  @override
  Stream<bool> get isCanceledStream =>
      _stateStream().map((e) => e == _ContextState.canceled);

  /// Futureをキャンセルする.
  ///
  /// すでにキャンセル済みの場合は何もしない.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContextImpl();
  /// await context.close();
  /// ```
  @override
  Future close() => _closeWith(next: _ContextState.canceled);

  /// 指定時間Contextを停止させる.
  ///
  /// [duration] 待機中にキャンセルが発生した場合、速やかに処理は停止する.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContextImpl();
  /// await context.delayed(const Duration(seconds: 1));
  /// ```
  @override
  Future delayed(final Duration duration) async {
    if (isCanceled) {
      throw CancellationException('${toString()} is canceled.');
    }

    // 完了時間タイマーを開始する.
    var timerDone = false;
    final timer = Timer(duration, () {
      timerDone = true;
      _notify();
    });

    try {
      await for (final _ in _controller.notifyStream) {
        if (isCanceled) {
          // キャンセルされたら、キャンセルを優先する
          throw CancellationException('${toString()} is canceled.');
        } else if (timerDone) {
          // 所定時間が経過したなら、これで完了
          return;
        }
      }
    } finally {
      timer.cancel();
    }
  }

  /// 関連するContextすべての [resume] を実行する.
  ///
  /// 自身がキャンセル済みなら [CancellationException] を投げる.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContextImpl();
  /// await context.resume();
  /// ```
  @override
  Future<void> resume() async {
    if (_state == _ContextState.canceled) {
      throw CancellationException('${toString()} is canceled.');
    }

    for (final c in _group) {
      await c.resume();
    }
  }

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
  /// final context = FutureContextImpl();
  /// final value = await context.suspend((c) async => 1);
  /// ```
  @override
  Future<T2> suspend<T2>(FutureSuspendBlock<T2> block) async {
    if (isCanceled) {
      throw CancellationException('${toString()} is canceled.');
    }

    var done = false;
    T2? result;
    Object? error;
    StackTrace? stackTrace;

    // 非同期処理を開始する
    // 完了したら、通知を発行する.
    unawaited(() async {
      await Future.delayed(Duration.zero);
      try {
        // 実行前に、実行可能状態まで待機する.
        await resume();
        result = await block(this);
      } on Object catch (e, s) {
        error = e;
        stackTrace = s;
      } finally {
        done = true;
        _notify();
      }
    }());

    // 通知を待ち合わせる.
    // キャンセルが発生していたらキャンセル例外を投げる.
    // 完了したら、結果を返却する.
    await for (final _ in _controller.notifyStream) {
      if (error != null) {
        // 発生した例外をチェックする.
        if (error is CancellationException) {
          throw CancellationException(
            '${toString()} is canceled. caused by exception: $error, stackTrace: $stackTrace',
          );
        } else {
          // 発生した例外をそのまま投げる
          // ignore: only_throw_errors
          throw error!;
        }
      } else if (isCanceled) {
        // その他、キャンセルが発生していたらキャンセルを投げる.
        throw CancellationException('${toString()} is canceled.');
      } else if (done) {
        // 処理が完了している.
        // 返却前に、実行可能であることをチェックする
        await resume();
        return result as T2;
      }
    }
    throw CancellationException('${toString()} is canceled.');
  }

  /// デバッグ表示用の文字列表現.
  ///
  /// Example:
  /// ```dart
  /// print(FutureContextImpl(tag: 'a')); // FutureContext(a)
  /// ```
  @override
  String toString() => 'FutureContext($tag)';

  /// タイムアウト付きの非同期処理を開始する.
  ///
  /// [timeout] 経過後、[block] は [TimeoutException] が発生して終了する.
  /// [request] は子Context生成時のデバッグ用オプション.
  ///
  /// Example:
  /// ```dart
  /// final context = FutureContextImpl();
  /// await context.withTimeout(
  ///   const Duration(seconds: 1),
  ///   (c) async => 'ok',
  /// );
  /// ```
  @override
  Future<T2> withTimeout<T2>(
    Duration timeout,
    FutureSuspendBlock<T2> block, {
    FutureContextRequest request = const FutureContextRequest(),
  }) async {
    final child = FutureContextImpl.child(
      this,
      debugCallStackLevel: request.debugCallStackLevel + 1,
    );
    try {
      return await child.suspend(block).timeout(timeout);
    } on TimeoutException catch (e) {
      throw TimeoutException('${e.message}, timeout: $timeout');
    } finally {
      await child.close();
    }
  }

  /// 状態を [next] へ進め、購読側へ通知する.
  ///
  /// すでに非アクティブなら状態は変えず、通知のみ行う.
  ///
  /// Example:
  /// ```dart
  /// // close() 経由で呼び出される.
  /// await context.close();
  /// ```
  Future _closeWith({
    required _ContextState next,
  }) async {
    if (_state == _ContextState.active) {
      _state = next;
    }
    _notify();
  }

  /// コントローラ経由でログを出力する.
  ///
  /// [message] の先頭に自身の文字列表現を付与する.
  ///
  /// Example:
  /// ```dart
  /// // 内部の状態ストリーム購読時に呼び出される.
  /// ```
  void _log(String message) {
    _controller.log('[$this] $message');
  }

  /// コントローラへ自身の更新を通知する.
  ///
  /// [delayed] や [suspend] の待機ループを再開させる副作用がある.
  ///
  /// Example:
  /// ```dart
  /// // Timer完了時やブロック終了時に呼び出される.
  /// ```
  void _notify() {
    _controller.notify(this);
  }

  /// キャンセル状態をハンドリングするStreamを返却する.
  ///
  /// キャンセルが発生していない場合でも、FutureContext全体通知が発生したタイミングで
  /// キャンセル状態を通知する.
  ///
  /// Example:
  /// ```dart
  /// // isCanceledStream の実装から呼び出される.
  /// await for (final canceled in context.isCanceledStream) {
  ///   if (canceled) break;
  /// }
  /// ```
  Stream<_ContextState> _stateStream() {
    return ConcatStream([
          Stream.value(_state),
          _controller.notifyStream.map((_) {
            return _state;
          }),
        ])
        .doOnListen(() {
          if (_state == _ContextState.canceled) {
            // すでにキャンセル済みの場合は、通知を発火することでフリーズを防ぐ
            _log('isCanceledStream.notify');
            Future.delayed(Duration.zero, () {
              _notify();
            });
          }
        })
        .transform(
          StreamTransformer.fromHandlers(
            handleData: (state, sink) {
              _log('CanceledStream.notify: $state');
              sink.add(state);
              if (state == _ContextState.canceled) {
                // キャンセルされたので、ここで終了.
                sink.close();
                return;
              }
            },
          ),
        );
  }

  /// 親グループ情報を加味したログ用タグを組み立てる.
  ///
  /// [group] が空でなければ親タグ一覧を接頭辞に付ける.
  /// [tag] が `null` のときは `NoName` を使う.
  ///
  /// Example:
  /// ```dart
  /// // コンストラクタの初期化リストから呼び出される.
  /// ```
  static String _getOptimizedTag({
    required Set<FutureContext> group,
    required String? tag,
  }) {
    if (group.isNotEmpty) {
      final builder = StringBuffer();
      builder.write('[');
      var i = 0;
      for (final p in group) {
        if (i > 0) {
          builder.write(',');
        }
        builder.write(p.tag);
        ++i;
      }
      builder.write(']#');
      builder.write(tag ?? 'NoName');
      return builder.toString();
    } else {
      return tag ?? 'NoName';
    }
  }

  /// デバッグ用の既定タグをStackTraceから生成する.
  ///
  /// [debugCallStackLevel] で取得するスタック行をずらす.
  /// リリースモードでは `null` を返す.
  ///
  /// Example:
  /// ```dart
  /// // コンストラクタで tag 省略時に呼び出される.
  /// ```
  static String? _newDefaultTag(int debugCallStackLevel) {
    if (kReleaseMode) {
      return null;
    } else {
      // StackTraceの先頭から3つ目のファイル・行を取得する
      const popLevel = kIsWeb ? 3 : 2;
      final trace = StackTrace.current.toString().split(
        '\n',
      )[popLevel + debugCallStackLevel];
      var file = trace.replaceAll(r'\', '/').split('/').last;
      final split = file.split(':');
      if (kIsWeb) {
        file = split[0].replaceAll('.dart', '.dart:').replaceAll('::', ':');
      } else if (split.length >= 2) {
        file = '${split[0]}:${split[1]}';
      }
      return file.replaceAll(')', '').replaceAll(' ', '');
    }
  }
}

/// FutureContextImplの内部状態.
enum _ContextState {
  /// 実行継続中.
  active,

  /// キャンセル済み.
  canceled,
}
