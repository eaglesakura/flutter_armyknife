import 'dart:async';

import 'package:armyknife_dartx/armyknife_dartx.dart';
import 'package:async_notify2/async_notify2.dart';
import 'package:flutter/foundation.dart';
import 'package:future_context2/src/future_context.dart';
import 'package:future_context2/src/future_context_request.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// port from https://github.com/vivitainc/flutter_future_context
/// 非同期（Async）状態を管理する.
/// FutureContextの目標はキャンセル可能な非同期処理のサポートである.
///
/// 処理終了後、必ずしも [close] をコールする必要はない（メモリリークはしない）が、
/// 設計上は [close] をコールすることを推奨する.
///
/// 開発者はFutureContext.suspend()に関数を渡し、実行を行う.
/// suspend()は実行前後にFutureContextの状態を確認し、必要であればキャンセル等の処理や中断を行う.
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
  static final _systemSubject = PublishSubject<FutureContextImpl>();

  /// このしきい値より短い時間の場合、delayed()はキャンセルチェックを行わず直接実行する.
  /// Streamの生成・破棄コストを最小化するためである.
  static const _delayedThreshold = Duration(milliseconds: 60);

  /// 親Context.
  final Set<FutureContext> _group;

  /// 現在の状態
  var _state = _ContextState.active;

  /// キャンセル識別用タグ
  @override
  final String tag;

  /// 空のFutureContextを作成する.
  FutureContextImpl({
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: const {},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = const {};

  /// 指定した親Contextを持つFutureContextを作成する.
  FutureContextImpl.child(
    FutureContextImpl parent, {
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: {parent},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = {parent};

  /// 指定した複数の親Contextを持つFutureContextを作成する.
  FutureContextImpl.group(
    Iterable<FutureContext> group, {
    String? tag,
    int debugCallStackLevel = 0,
  }) : tag = _getOptimizedTag(
         group: {...group},
         tag: tag ?? _newDefaultTag(debugCallStackLevel),
       ),
       _group = {...group};

  /// 処理が継続中の場合trueを返却する.
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

  /// 処理がキャンセル済みの場合true.
  @override
  bool get isCanceled {
    // 軽量処理を選考して呼び出す
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

  /// キャンセル状態をハンドリングするStreamを返却する.
  @override
  Stream<bool> get isCanceledStream => _isCanceledStream();

  /// Futureをキャンセルする.
  /// すでにキャンセル済みの場合は何もしない.
  @override
  Future close() => _closeWith(next: _ContextState.canceled);

  /// 指定時間Contextを停止させる.
  /// delayed()の最中にキャンセルが発生した場合、速やかにContext処理は停止する.
  ///
  /// e.g.
  /// context.delayed(Duration(seconds: 1));
  @override
  Future delayed(final Duration duration) async {
    _resume();
    // _delayedThresholdよりもdurationが小さいなら直接delayedをかける
    if (duration < _delayedThreshold) {
      await Future.delayed(duration);
      _resume();
      return;
    } else {
      // キャンセル最適化を行う
      final complete = Completer<int>();
      final timer = Timer(duration, () {
        if (!complete.isCompleted) {
          _log('delayed.done: $duration');
          complete.complete(0);
        }
      });
      final subscribe = isCanceledStream.where((event) => event).take(1).listen(
        (event) {
          if (!complete.isCompleted) {
            _log('delayed.cancel: $duration');
            complete.complete(1);
          }
        },
      );
      try {
        await complete.future;
        _resume();
      } finally {
        await subscribe.cancel();
        timer.cancel();
      }
    }
  }

  @override
  T? queryInterface<T>() {
    if (typeEquals<T, FutureContextImpl>()) {
      return this as T;
    }
    return null;
  }

  /// 非同期処理の特定1ブロックを実行する.
  /// これはFutureContext(T)の実行最小単位として機能する.
  /// suspend内部では実行開始時・終了時にそれぞれAsyncContextのステートチェックを行い、
  /// 必要であれば例外を投げる等の中断処理を行う.
  ///
  /// 開発者は可能な限り細切れに suspend() に処理を分割することで、
  /// 処理の速やかな中断のサポートを受けることができる.
  ///
  /// suspend()関数は1コールのオーバーヘッドが大きいため、
  /// 内部でキャンセル処理が必要なほど長い場合に利用する.
  @override
  Future<T2> suspend<T2>(FutureSuspendBlock<T2> block) async {
    _resume();

    final stackTrace = StackTrace.current;
    final complete = Completer<T2>();
    final subscribe = isCanceledStream
        .takeWhile((_) => !complete.isCompleted)
        .where((event) => event)
        .listen((event) {
          if (!complete.isCompleted) {
            complete.completeError(
              CancellationException('${toString()} is canceled.'),
              stackTrace,
            );
          }
        });
    final future = complete.future;
    unawaited(() async {
      try {
        final result = await block(this);
        if (!complete.isCompleted) {
          complete.complete(result);
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e, trace) {
        if (!complete.isCompleted) {
          complete.completeError(
            e,
            StackTrace.fromString('$trace\n$stackTrace'),
          );
        }
      } finally {
        _notify();
      }
    }());
    try {
      final result = await future;
      _resume();
      return result;
    } finally {
      _notify();
      await subscribe.cancel();
    }
  }

  @override
  String toString() => 'FutureContext($tag)';

  /// タイムアウト付きの非同期処理を開始する.
  ///
  /// タイムアウトが発生した場合、
  /// block()は [TimeoutException] が発生して終了する.
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

  Future _closeWith({
    required _ContextState next,
  }) async {
    if (_state == _ContextState.active) {
      _state = next;
    }
    _notify();
  }

  Stream<bool> _isCanceledStream() async* {
    try {
      _log('isCanceledStream start');
      if (isCanceled) {
        // すでに閉じられていたら終了
        yield true;
        return;
      }
      // 閉じられるまでイベントを待つ
      yield false;
      await for (final _ in _systemSubject) {
        if (isCanceled) {
          yield true;
          return;
        }
        yield false;
      }
    } finally {
      _log('isCanceledStream close');
    }
  }

  void _log(String message) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('[$this] $message');
  }

  void _notify() {
    _systemSubject.add(this);
  }

  /// 非同期処理の状態をチェックし、必要であれはキャンセル処理を発生させる.
  void _resume() {
    // 自分自身のResume Check.
    try {
      if (isCanceled) {
        throw CancellationException('${toString()} is canceled.');
      }
    } finally {
      _notify();
    }
  }

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

enum _ContextState {
  active,
  canceled,
}
