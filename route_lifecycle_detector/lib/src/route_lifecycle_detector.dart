import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:meta/meta.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle_notify.dart';
import 'package:rxdart/rxdart.dart';

/// Detects the lifecycle of a Route (such as Scaffold, Dialog, etc.).
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
  /// Notify for RouteLifecycleNotify.
  @internal
  // ignore: close_sinks
  static final notify = BehaviorSubject<RouteLifecycleNotify>();

  /// Observer to add to the observers of MaterialApp.
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
    notify,
  );

  RouteLifecycleDetector._();
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
