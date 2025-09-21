import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_fgbg/flutter_fgbg.dart";
import "package:route_lifecycle_detector/src/route_lifecycle.dart";
import "package:route_lifecycle_detector/src/route_lifecycle_notify.dart";
import "package:rxdart/rxdart.dart";

/// Route(Scaffold, Dialog, etc.)のライフサイクルを検出する.
///
/// e.g.
/// ```dart
/// MaterialApp(
///   observers: [
///     RouteLifecycleDetector.observer,
///   ],
/// )
/// ```
class RouteLifecycleDetector {
  // ignore: close_sinks
  static final _notifySubject = BehaviorSubject<RouteLifecycleNotify>();

  /// MaterialAppのobserversに追加するためのObserver.
  ///
  /// e.g.
  /// ```dart
  /// MaterialApp(
  ///   navigatorObservers: [
  ///     RouteLifecycleDetector.observer,
  ///   ],
  /// )
  /// ```
  static final NavigatorObserver navigatorObserver = _NavigationObserver(
    _notifySubject,
  );

  RouteLifecycleDetector._();

  /// Route(Scaffold, Dialog, etc.)のライフサイクルを検出する.
  /// [RouteLifecycle.destroyed] になった場合にStreamを終了する.
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

            return _notifySubject.stream
                .map((event) {
                  // ignore: use_build_context_synchronously
                  return RouteLifecycle.of(context);
                })
                .transform(
                  StreamTransformer.fromHandlers(
                    handleData: (lifecycle, sink) {
                      sink.add(lifecycle);
                      // destroyedの場合はイベントを出力後にストリームを終了する
                      if (lifecycle == RouteLifecycle.destroyed) {
                        sink.close();
                      }
                    },
                  ),
                );
          },
        );
    return ConcatStream([initialStream, mainStream]).distinct();
  }

  /// [context] が所属しているModalRouteが[RouteLifecycle.active]または[RouteLifecycle.destroyed]になった場合に、その状態を返す.
  /// この関数は、他の画面が開いている場合、 [BuildContext] が属しているModalRouteが最前面になるまで待つことができる.
  static Future<RouteLifecycle> waitResumeOrDestroy(
    BuildContext context,
  ) async {
    // 初期状態が問題なければ、そこで終了
    {
      final initialLifecycle = RouteLifecycle.of(context);
      if (initialLifecycle == RouteLifecycle.active ||
          initialLifecycle == RouteLifecycle.destroyed) {
        return initialLifecycle;
      }
    }

    // ignore: use_build_context_synchronously
    final stream = streamOf(context);
    await for (final lifecycle in stream) {
      if (lifecycle == RouteLifecycle.active ||
          lifecycle == RouteLifecycle.destroyed) {
        return lifecycle;
      }
    }
    // Streamが終了した場合も、最後の状態を返す.
    // ignore: use_build_context_synchronously
    return RouteLifecycle.of(context);
  }
}

class _NavigationObserver extends NavigatorObserver {
  final Subject<RouteLifecycleNotify> notifySubject;

  _NavigationObserver(this.notifySubject) {
    FGBGEvents.instance.stream.listen((data) {
      notifySubject.add(switch (data) {
        FGBGType.foreground => const RouteLifecycleNotify.didForeground(),
        FGBGType.background => const RouteLifecycleNotify.didBackground(),
      });
    });
  }

  @override
  void didChangeTop(
    Route<dynamic> topRoute,
    Route<dynamic>? previousTopRoute,
  ) {
    notifySubject.add(
      RouteLifecycleNotify.didChangeTop(
        topRoute: topRoute,
        previousTopRoute: previousTopRoute,
      ),
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didPop(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didPush(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didRemove(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    notifySubject.add(
      RouteLifecycleNotify.didReplace(
        newRoute: newRoute,
        oldRoute: oldRoute,
      ),
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    notifySubject.add(
      RouteLifecycleNotify.didStartUserGesture(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  @override
  void didStopUserGesture() {
    notifySubject.add(
      const RouteLifecycleNotify.didStopUserGesture(),
    );
  }
}
