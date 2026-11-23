import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle_detector.dart';
import 'package:rxdart/rxdart.dart';

part 'route_lifecycle.freezed.dart';

/// Route(Scaffold・Dialog等)の現在ライフサイクル状態.
///
/// AndroidのLifecycleより単純で、取得時点の情報だけで判定する.
/// アプリ前景/背景は [isForeground] で表し、Routeのスタック位置はバリアントで表す.
@freezed
sealed class RouteLifecycle with _$RouteLifecycle {
  /// アプリが前景で、Routeがスタック最前面にある状態.
  ///
  /// ユーザー操作を受け付ける想定の状態.
  ///
  /// Example:
  /// ```dart
  /// final lifecycle = RouteLifecycle.active(isForeground: true);
  /// ```
  const factory RouteLifecycle.active({
    /// アプリが前景かどうか.
    required bool isForeground,
  }) = RouteLifecycleActive;

  /// Widget構築中で、まだModalRouteが取得できない状態.
  ///
  /// [BuildContext] はmountedだが、[ModalRoute.of] が失敗する段階を表す.
  ///
  /// Example:
  /// ```dart
  /// final lifecycle = RouteLifecycle.building(isForeground: true);
  /// ```
  const factory RouteLifecycle.building({
    /// アプリが前景かどうか.
    required bool isForeground,
  }) = RouteLifecycleBuilding;

  /// Widget・ModalRoute・BuildContextのいずれかが破棄された状態.
  ///
  /// ストリーム監視ではこの状態の通知後に購読が終了する.
  ///
  /// Example:
  /// ```dart
  /// final lifecycle = RouteLifecycle.destroyed(isForeground: false);
  /// ```
  const factory RouteLifecycle.destroyed({
    /// アプリが前景かどうか.
    required bool isForeground,
  }) = RouteLifecycleDestroyed;

  /// Routeがスタック最前面ではなく、別画面が前面にある状態.
  ///
  /// Route自体は生存しているが、ユーザー操作は想定しない.
  ///
  /// Example:
  /// ```dart
  /// final lifecycle = RouteLifecycle.inactive(isForeground: true);
  /// ```
  const factory RouteLifecycle.inactive({
    /// アプリが前景かどうか.
    required bool isForeground,
  }) = RouteLifecycleInactive;

  /// [context] 時点のライフサイクル状態を取得する.
  ///
  /// NOTE:
  /// [BuildContext.mounted] は内部で確認するため、呼び出し側での事前判定は不要.
  /// mountedでない、またはRouteが非activeの場合は [RouteLifecycle.destroyed] を返す.
  /// ModalRoute未取得時は [RouteLifecycle.building] を返す.
  ///
  /// Example:
  /// ```dart
  /// final lifecycle = RouteLifecycle.of(context);
  /// if (lifecycle is RouteLifecycleActive) {
  ///   // 最前面かつ操作可能
  /// }
  /// ```
  static RouteLifecycle of(BuildContext context) {
    final isForeground = FGBGEvents.last == FGBGType.foreground;
    if (!context.mounted) {
      /// BuildContextが破棄されているならば、破棄状態.
      return RouteLifecycle.destroyed(
        isForeground: isForeground,
      );
    }

    /// Routeが破棄されているならば、破棄状態.
    late final ModalRoute<dynamic> route;
    try {
      route = ModalRoute.of(context)!;
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // drop error
      return RouteLifecycle.building(
        isForeground: isForeground,
      );
    }

    /// アプリが最前面にあるが、Routeが最前面ではないならば、一時停止状態
    if (!route.isCurrent) {
      if (route.isActive) {
        // まだRouteが生きているなら、pause
        return RouteLifecycle.inactive(
          isForeground: isForeground,
        );
      } else {
        // すでにRouteが破棄されているなら、破棄状態
        return RouteLifecycle.destroyed(
          isForeground: isForeground,
        );
      }
    }

    /// すべての状態を満たしているならば、実行中状態
    return RouteLifecycle.active(
      isForeground: isForeground,
    );
  }

  /// [context] に紐づくRouteライフサイクル変化を監視するStreamを返す.
  ///
  /// 初回値を即時通知したあと、[RouteLifecycleDetector.notify] 経由の変化を購読する.
  /// [RouteLifecycle.destroyed] 到達時は値を流したうえでStreamを閉じる.
  /// 連続同一状態は [Stream.distinct] で間引く.
  ///
  /// 前提として `MaterialApp.navigatorObservers` 等へ [RouteLifecycleDetector.navigatorObserver] の登録が必要.
  ///
  /// Example:
  /// ```dart
  /// RouteLifecycle.streamOf(context).listen((lifecycle) {
  ///   print(lifecycle);
  /// });
  /// ```
  static Stream<RouteLifecycle> streamOf(BuildContext context) {
    // 初期値を通知するStream.
    // NOTE.
    // ModalRouteの管理を簡略化するため、初期値送信と2回目以降の送信を分離する.
    final initialStream = Stream.value(RouteLifecycle.of(context));

    // Routeのライフサイクルイベント通知Stream.
    final mainStream =
        Stream.fromFuture(() async {
          do {
            try {
              return ModalRoute.of(context);
              // ignore: avoid_catches_without_on_clauses
            } catch (_) {
              // drop error
              await Future<void>.delayed(Duration.zero);
            }
          } while (context.mounted);

          return null;
        }()).switchMap<RouteLifecycle>(
          (route) {
            if (route == null) {
              return Stream.value(RouteLifecycle.of(context));
            }

            return RouteLifecycleDetector.notify.stream
                .map((event) {
                  // ignore: use_build_context_synchronously
                  return RouteLifecycle.of(context);
                })
                .transform(
                  StreamTransformer.fromHandlers(
                    handleData: (lifecycle, sink) {
                      sink.add(lifecycle);
                      // destroyedの場合はイベントを出力後にストリームを終了する
                      if (lifecycle is RouteLifecycleDestroyed) {
                        sink.close();
                      }
                    },
                  ),
                );
          },
        );
    return ConcatStream([initialStream, mainStream]).distinct();
  }
}
