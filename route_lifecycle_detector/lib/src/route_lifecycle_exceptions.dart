import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

/// 期待するライフサイクルへ到達できなかった場合の例外.
///
/// [BuildContextRouteLifecycleExtensions.waitLifecycleWith] 等で、
/// [RouteLifecycle.destroyed] 到達により待機が打ち切られたときに送出される.
class BadLifecycleException implements Exception {
  /// 待機打ち切り時点の最新ライフサイクル.
  final RouteLifecycle latestLifecycle;

  /// [latestLifecycle] を保持する例外を生成する.
  ///
  /// Example:
  /// ```dart
  /// throw BadLifecycleException(
  ///   RouteLifecycle.destroyed(isForeground: false),
  /// );
  /// ```
  BadLifecycleException(this.latestLifecycle);

  /// 例外メッセージを返す.
  ///
  /// Example:
  /// ```dart
  /// final message = BadLifecycleException(
  ///   RouteLifecycle.destroyed(isForeground: false),
  /// ).toString();
  /// ```
  @override
  String toString() {
    return 'BadLifecycleException: $latestLifecycle';
  }
}
