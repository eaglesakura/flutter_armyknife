import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle_detector.dart';
import 'package:rxdart/rxdart.dart';

part 'route_lifecycle.freezed.dart';

/// The current lifecycle state of a Route (such as Scaffold, Dialog, etc.).
/// It is simpler than Android's Lifecycle because it is determined only by the current information.
@freezed
sealed class RouteLifecycle with _$RouteLifecycle {
  /// The app is in the foreground and the Route is at the top of the stack.
  ///
  /// State:
  ///   - Route: Top of stack.
  const factory RouteLifecycle.active({
    /// Route is at the top of the stack.
    required ModalRoute<dynamic> route,

    /// App is in the foreground.
    required bool isForeground,
  }) = RouteLifecycleActive;

  /// The widget is being built and the Route has not yet been created.
  const factory RouteLifecycle.building({
    /// App is in the foreground.
    required bool isForeground,
  }) = RouteLifecycleBuilding;

  /// One of Widget, ModalRoute, or BuildContext has been disposed.
  ///
  /// State:
  ///   - App: any.
  ///   - Route: destroyed.
  const factory RouteLifecycle.destroyed({
    /// Route is at the top of the stack.
    required ModalRoute<dynamic>? route,

    /// App is in the foreground.
    required bool isForeground,
  }) = RouteLifecycleDestroyed;

  /// The app is in the foreground, but the Route is not at the top of the stack.
  /// It is assumed that the user cannot interact with this Route because another page is in the foreground.
  ///
  /// State:
  ///   - Route: Not top of stack.
  const factory RouteLifecycle.inactive({
    /// Route is at the top of the stack.
    required ModalRoute<dynamic> route,

    /// App is in the foreground.
    required bool isForeground,
  }) = RouteLifecycleInactive;

  /// Gets the current lifecycle state.
  ///
  /// NOTE:
  /// [BuildContext.mounted] is checked internally, so callers do not need to consider it.
  static RouteLifecycle of(BuildContext context) {
    final isForeground = FGBGEvents.last == FGBGType.foreground;
    if (!context.mounted) {
      /// BuildContextが破棄されているならば、破棄状態.
      return RouteLifecycle.destroyed(
        route: null,
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
          route: route,
          isForeground: isForeground,
        );
      } else {
        // すでにRouteが破棄されているなら、破棄状態
        return RouteLifecycle.destroyed(
          route: route,
          isForeground: isForeground,
        );
      }
    }

    /// すべての状態を満たしているならば、実行中状態
    return RouteLifecycle.active(
      route: route,
      isForeground: isForeground,
    );
  }

  /// Detects the lifecycle of a Route (such as Scaffold, Dialog, etc.).
  /// The stream will be closed when [RouteLifecycle.destroyed] is reached.
  ///
  /// e.g.
  /// ```dart
  /// RouteLifecycleDetector.streamOf(context).listen((lifecycle) {
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
