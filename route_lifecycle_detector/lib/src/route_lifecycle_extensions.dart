import 'package:flutter/material.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle.dart';

/// Extensions for BuildContext to detect the lifecycle of a Route.
extension BuildContextRouteLifecycleExtensions on BuildContext {
  /// Waits until the BuildContext's lifecycle satisfies [test].
  ///
  /// If the lifecycle reaches [RouteLifecycle.destroyed] before reaching the specified lifecycle,
  /// an exception will be thrown.
  Future<RouteLifecycle> waitLifecycleWith(
    bool Function(RouteLifecycle lifecycle) test,
  ) async {
    // 初期状態が問題なければ、そこで終了
    var latestLifecycle = RouteLifecycle.of(this);
    {
      latestLifecycle = RouteLifecycle.of(this);
      if (test(latestLifecycle)) {
        return latestLifecycle;
      }
    }

    final stream = RouteLifecycle.streamOf(this);
    await for (final lifecycle in stream) {
      latestLifecycle = lifecycle;
      if (test(latestLifecycle)) {
        return latestLifecycle;
      }
    }
    // Streamが終了した場合も、最後の状態を返す.
    throw BadLifecycleException(latestLifecycle);
  }
}

/// Exception thrown when the route lifecycle is invalid.
class BadLifecycleException implements Exception {
  final RouteLifecycle latestLifecycle;

  BadLifecycleException(this.latestLifecycle);

  @override
  String toString() {
    return "BadLifecycleException: $latestLifecycle";
  }
}
