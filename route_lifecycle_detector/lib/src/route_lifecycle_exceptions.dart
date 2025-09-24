import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

/// Exception thrown when the route lifecycle is invalid.
class BadLifecycleException implements Exception {
  /// The latest lifecycle.
  final RouteLifecycle latestLifecycle;

  BadLifecycleException(this.latestLifecycle);

  @override
  String toString() {
    return 'BadLifecycleException: $latestLifecycle';
  }
}
