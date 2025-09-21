import "package:flutter/material.dart";
import "package:flutter_fgbg/flutter_fgbg.dart";

/// Route(Scaffold, Dialog, etc.)の、現在のライフサイクル状態.
/// 現在の情報のみで判断するため、AndroidのLifecycleに比べてシンプルである.
enum RouteLifecycle {
  /// Widgetビルド中であり、まだRouteが生成されていない.
  building,

  /// 実行中.
  ///
  /// State:
  ///   - App: Foreground.
  ///   - Route: Top of stack.
  active,

  /// 一時停止.
  ///
  /// State:
  ///   - App: Foreground.
  ///   - Route: Not top of stack.
  inactive,

  /// アプリがバックグラウンド状態である.
  ///
  /// State:
  ///   - App: Background.
  ///   - Route: any.
  hidden,

  /// 破棄.
  ///
  /// State:
  ///   - App: any.
  ///   - Route: destroyed.
  destroyed;

  /// 現在のライフサイクル状態を取得する.
  static RouteLifecycle of(BuildContext context) {
    if (!context.mounted) {
      /// BuildContextが破棄されているならば、破棄状態.
      return RouteLifecycle.destroyed;
    }

    /// Routeが破棄されているならば、破棄状態.
    late final ModalRoute<dynamic> route;
    try {
      route = ModalRoute.of(context)!;
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      // drop error
      return RouteLifecycle.building;
    }

    /// アプリが最前面に無いのならば、停止状態
    if (FGBGEvents.last != FGBGType.foreground) {
      return RouteLifecycle.hidden;
    }

    /// アプリが最前面にあるが、Routeが最前面ではないならば、一時停止状態
    if (!route.isCurrent) {
      if (route.isActive) {
        // まだRouteが生きているなら、pause
        return RouteLifecycle.inactive;
      } else {
        // すでにRouteが破棄されているなら、破棄状態
        return RouteLifecycle.destroyed;
      }
    }

    /// すべての状態を満たしているならば、実行中状態
    return RouteLifecycle.active;
  }
}
