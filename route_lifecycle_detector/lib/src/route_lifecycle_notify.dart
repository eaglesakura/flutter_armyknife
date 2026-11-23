import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart' show FGBGEvents, FGBGType;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_lifecycle_notify.freezed.dart';

/// Route(Scaffold・Dialog等)のライフサイクル変化イベント.
///
/// `RouteLifecycleDetector.navigatorObserver` が収集し、`RouteLifecycleDetector.notify` 経由で配信する.
/// 公開APIではなく、パッケージ内部の再計算トリガーとして使う.
@internal
@freezed
sealed class RouteLifecycleNotify with _$RouteLifecycleNotify {
  /// [FGBGEvents.stream] が [FGBGType.background] になったときに通知する.
  ///
  /// Example:
  /// ```dart
  /// const notify = RouteLifecycleNotify.didBackground();
  /// ```
  const factory RouteLifecycleNotify.didBackground() =
      RouteLifecycleNotifyDidBackground;

  /// [NavigatorObserver.didChangeTop] が呼ばれたときに通知する.
  ///
  /// [topRoute] は新しい最前面、[previousTopRoute] は直前の最前面.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didChangeTop(
  ///   topRoute: current,
  ///   previousTopRoute: previous,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didChangeTop({
    /// 新しい最前面Route.
    required Route<dynamic> topRoute,
    /// 直前の最前面Route. 無い場合は `null`.
    required Route<dynamic>? previousTopRoute,
  }) = RouteLifecycleNotifyDidChangeTop;

  /// [FGBGEvents.stream] が [FGBGType.foreground] になったときに通知する.
  ///
  /// Example:
  /// ```dart
  /// const notify = RouteLifecycleNotify.didForeground();
  /// ```
  const factory RouteLifecycleNotify.didForeground() =
      RouteLifecycleNotifyDidForeground;

  /// [NavigatorObserver.didPop] が呼ばれたときに通知する.
  ///
  /// [route] はpopされたRoute、[previousRoute] は露出するRoute.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didPop(
  ///   route: popped,
  ///   previousRoute: below,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didPop({
    /// popされたRoute.
    required Route<dynamic> route,
    /// 露出するRoute. 無い場合は `null`.
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidPop;

  /// [NavigatorObserver.didPush] が呼ばれたときに通知する.
  ///
  /// [route] はpushされたRoute、[previousRoute] は下に残るRoute.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didPush(
  ///   route: pushed,
  ///   previousRoute: below,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didPush({
    /// pushされたRoute.
    required Route<dynamic> route,
    /// 下に残るRoute. 無い場合は `null`.
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidPush;

  /// [NavigatorObserver.didRemove] が呼ばれたときに通知する.
  ///
  /// [route] は除去されたRoute、[previousRoute] は直前のRoute.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didRemove(
  ///   route: removed,
  ///   previousRoute: previous,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didRemove({
    /// 除去されたRoute.
    required Route<dynamic> route,
    /// 直前のRoute. 無い場合は `null`.
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidRemove;

  /// [NavigatorObserver.didReplace] が呼ばれたときに通知する.
  ///
  /// [newRoute] は置き換え後、[oldRoute] は置き換え前.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didReplace(
  ///   newRoute: next,
  ///   oldRoute: previous,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didReplace({
    /// 置き換え後のRoute. 無い場合は `null`.
    required Route<dynamic>? newRoute,
    /// 置き換え前のRoute. 無い場合は `null`.
    required Route<dynamic>? oldRoute,
  }) = RouteLifecycleNotifyDidReplace;

  /// [NavigatorObserver.didStartUserGesture] が呼ばれたときに通知する.
  ///
  /// [route] はジェスチャ対象、[previousRoute] は下のRoute.
  ///
  /// Example:
  /// ```dart
  /// final notify = RouteLifecycleNotify.didStartUserGesture(
  ///   route: current,
  ///   previousRoute: below,
  /// );
  /// ```
  const factory RouteLifecycleNotify.didStartUserGesture({
    /// ジェスチャ対象のRoute.
    required Route<dynamic> route,
    /// 下のRoute. 無い場合は `null`.
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidStartUserGesture;

  /// [NavigatorObserver.didStopUserGesture] が呼ばれたときに通知する.
  ///
  /// Example:
  /// ```dart
  /// const notify = RouteLifecycleNotify.didStopUserGesture();
  /// ```
  const factory RouteLifecycleNotify.didStopUserGesture() =
      RouteLifecycleNotifyDidStopUserGesture;

  /// freezed用の私有コンストラクタ.
  const RouteLifecycleNotify._();

  /// 引数の [route] が関係している通知であればtrue.
  ///
  /// 前景/背景・ジェスチャ終了など、特定Routeに紐づかない通知は常にtrue.
  ///
  /// Example:
  /// ```dart
  /// final related = notify.isRelatedTo(modalRoute);
  /// ```
  bool isRelatedTo(ModalRoute<dynamic> route) {
    final self = this;
    return switch (self) {
      RouteLifecycleNotifyDidChangeTop() =>
        self.topRoute == route || self.previousTopRoute == route,
      RouteLifecycleNotifyDidPop() =>
        self.route == route || self.previousRoute == route,
      RouteLifecycleNotifyDidPush() =>
        self.route == route || self.previousRoute == route,
      RouteLifecycleNotifyDidRemove() =>
        self.route == route || self.previousRoute == route,
      RouteLifecycleNotifyDidReplace() =>
        self.newRoute == route || self.oldRoute == route,
      RouteLifecycleNotifyDidStartUserGesture() =>
        self.route == route || self.previousRoute == route,
      RouteLifecycleNotifyDidStopUserGesture() => true,
      RouteLifecycleNotifyDidBackground() => true,
      RouteLifecycleNotifyDidForeground() => true,
    };
  }
}
