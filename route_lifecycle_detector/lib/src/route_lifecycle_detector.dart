import 'package:flutter/widgets.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:meta/meta.dart';
import 'package:route_lifecycle_detector/src/route_lifecycle_notify.dart';
import 'package:rxdart/rxdart.dart';

/// Route(Scaffold・Dialog等)のライフサイクル変化を検知する入口.
///
/// [navigatorObserver] を `MaterialApp.navigatorObservers` へ登録し、
/// 前景/背景とナビゲーションイベントを [notify] へ流す.
///
/// Example:
/// ```dart
/// MaterialApp(
///   navigatorObservers: [
///     RouteLifecycleDetector.navigatorObserver,
///   ],
/// )
/// ```
class RouteLifecycleDetector {
  /// ライフサイクル変化の内部通知用Subject.
  ///
  /// `RouteLifecycle.streamOf` 等が購読する.
  /// 利用側から直接addしない想定.
  @internal
  // ignore: close_sinks
  static final notify = BehaviorSubject<RouteLifecycleNotify>();

  /// `MaterialApp.navigatorObservers` へ登録するObserver.
  ///
  /// 未登録のまま `RouteLifecycle.streamOf` を使うと、初期値以外の変化が届かない.
  ///
  /// Example:
  /// ```dart
  /// MaterialApp(
  ///   navigatorObservers: [
  ///     RouteLifecycleDetector.navigatorObserver,
  ///   ],
  /// )
  /// ```
  static final NavigatorObserver navigatorObserver = _NavigationObserver(
    notify,
  );

  /// インスタンス化を禁止する.
  RouteLifecycleDetector._();
}

/// ナビゲーションと前景/背景変化を [RouteLifecycleNotify] へ橋渡しするObserver.
class _NavigationObserver extends NavigatorObserver {
  /// 通知先Subject.
  final Subject<RouteLifecycleNotify> notifySubject;

  /// [notifySubject] へイベントを流すObserverを生成する.
  ///
  /// 生成時に [FGBGEvents] の購読も開始する.
  ///
  /// Example:
  /// ```dart
  /// // RouteLifecycleDetector.navigatorObserver 経由で利用する
  /// final observer = RouteLifecycleDetector.navigatorObserver;
  /// ```
  _NavigationObserver(this.notifySubject) {
    FGBGEvents.instance.stream.listen((data) {
      notifySubject.add(switch (data) {
        FGBGType.foreground => const RouteLifecycleNotify.didForeground(),
        FGBGType.background => const RouteLifecycleNotify.didBackground(),
      });
    });
  }

  /// 最前面Routeの入れ替えを通知する.
  ///
  /// Example:
  /// ```dart
  /// // Navigatorの遷移に応じて自動で呼ばれる
  /// ```
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

  /// Routeのpopを通知する.
  ///
  /// Example:
  /// ```dart
  /// // Navigator.pop 等に応じて自動で呼ばれる
  /// ```
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didPop(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  /// Routeのpushを通知する.
  ///
  /// Example:
  /// ```dart
  /// // Navigator.push 等に応じて自動で呼ばれる
  /// ```
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didPush(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  /// Routeのremoveを通知する.
  ///
  /// Example:
  /// ```dart
  /// // Navigator.removeRoute 等に応じて自動で呼ばれる
  /// ```
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    notifySubject.add(
      RouteLifecycleNotify.didRemove(
        route: route,
        previousRoute: previousRoute,
      ),
    );
  }

  /// Routeのreplaceを通知する.
  ///
  /// Example:
  /// ```dart
  /// // Navigator.replace 等に応じて自動で呼ばれる
  /// ```
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    notifySubject.add(
      RouteLifecycleNotify.didReplace(
        newRoute: newRoute,
        oldRoute: oldRoute,
      ),
    );
  }

  /// ユーザージェスチャ開始を通知する.
  ///
  /// Example:
  /// ```dart
  /// // iOSの戻るスワイプ開始等に応じて自動で呼ばれる
  /// ```
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

  /// ユーザージェスチャ終了を通知する.
  ///
  /// Example:
  /// ```dart
  /// // 戻るスワイプ完了/キャンセル等に応じて自動で呼ばれる
  /// ```
  @override
  void didStopUserGesture() {
    notifySubject.add(
      const RouteLifecycleNotify.didStopUserGesture(),
    );
  }
}
