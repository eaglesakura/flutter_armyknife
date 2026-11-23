import 'package:flutter/widgets.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle_exceptions.dart';

/// [BuildContext] からRouteライフサイクルを待つための拡張.
extension BuildContextRouteLifecycleExtensions on BuildContext {
  /// ライフサイクルが [test] を満たすまで待機する.
  ///
  /// 既に [test] を満たしていれば即時にその状態を返す.
  /// 満たす前に [RouteLifecycle.destroyed] へ到達しStreamが閉じた場合は [BadLifecycleException] を投げる.
  ///
  /// Example:
  /// ```dart
  /// final active = await context.waitLifecycleWith(
  ///   (lifecycle) => lifecycle is RouteLifecycleActive,
  /// );
  /// ```
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
    throw BadLifecycleException(latestLifecycle);
  }
}
