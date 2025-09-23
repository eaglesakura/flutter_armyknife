/// Exception thrown when the route lifecycle is invalid.
class BadLifecycleException implements Exception {
  final RouteLifecycle latestLifecycle;

  BadLifecycleException(this.latestLifecycle);

  @override
  String toString() {
    return "BadLifecycleException: $latestLifecycle";
  }
}
