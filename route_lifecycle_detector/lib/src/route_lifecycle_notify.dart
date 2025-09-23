import 'package:flutter/material.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart' show FGBGEvents, FGBGType;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_lifecycle_notify.freezed.dart';

/// Route(Scaffold, Dialog, etc.)のライフサイクルを通知する.
@internal
@freezed
sealed class RouteLifecycleNotify with _$RouteLifecycleNotify {
  /// [FGBGEvents.stream] が [FGBGType.background] になったときに通知する.
  const factory RouteLifecycleNotify.didBackground() =
      RouteLifecycleNotifyDidBackground;

  /// [NavigatorObserver.didChangeTop] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didChangeTop({
    required Route<dynamic> topRoute,
    required Route<dynamic>? previousTopRoute,
  }) = RouteLifecycleNotifyDidChangeTop;

  /// [FGBGEvents.stream] が [FGBGType.foreground] になったときに通知する.
  const factory RouteLifecycleNotify.didForeground() =
      RouteLifecycleNotifyDidForeground;

  /// [NavigatorObserver.didPop] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didPop({
    required Route<dynamic> route,
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidPop;

  /// [NavigatorObserver.didPush] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didPush({
    required Route<dynamic> route,
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidPush;

  /// [NavigatorObserver.didRemove] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didRemove({
    required Route<dynamic> route,
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidRemove;

  /// [NavigatorObserver.didReplace] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didReplace({
    required Route<dynamic>? newRoute,
    required Route<dynamic>? oldRoute,
  }) = RouteLifecycleNotifyDidReplace;

  /// [NavigatorObserver.didStartUserGesture] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didStartUserGesture({
    required Route<dynamic> route,
    required Route<dynamic>? previousRoute,
  }) = RouteLifecycleNotifyDidStartUserGesture;

  /// [NavigatorObserver.didStopUserGesture] が呼ばれたときに通知する.
  const factory RouteLifecycleNotify.didStopUserGesture() =
      RouteLifecycleNotifyDidStopUserGesture;

  const RouteLifecycleNotify._();

  /// 引数の [ModalRoute] が関係している通知であればtrue.
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
