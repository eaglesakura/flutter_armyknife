import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

/// The current lifecycle state of a Route (such as Scaffold, Dialog, etc.).
/// It is simpler than Android's Lifecycle because it is determined only by the current information.
enum RouteLifecycle {
  /// The widget is being built and the Route has not yet been created.
  building,

  /// The app is in the foreground and the Route is at the top of the stack.
  ///
  /// State:
  ///   - App: Foreground.
  ///   - Route: Top of stack.
  active,

  /// The app is in the foreground, but the Route is not at the top of the stack.
  /// It is assumed that the user cannot interact with this Route because another page is in the foreground.
  ///
  /// State:
  ///   - App: Foreground.
  ///   - Route: Not top of stack.
  inactive,

  /// The app is in the background.
  /// The app screen is completely hidden, so user interaction is not possible.
  ///
  /// State:
  ///   - App: Background.
  ///   - Route: any.
  hidden,

  /// One of Widget, ModalRoute, or BuildContext has been disposed.
  ///
  /// State:
  ///   - App: any.
  ///   - Route: destroyed.
  destroyed;

  /// Gets the current lifecycle state.
  ///
  /// NOTE:
  /// [BuildContext.mounted] is checked internally, so callers do not need to consider it.
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
