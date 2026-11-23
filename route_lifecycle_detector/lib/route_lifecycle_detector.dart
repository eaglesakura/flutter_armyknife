/// Routeのライフサイクル検知APIを集約する.
///
/// ライフサイクル状態・検知器・例外・BuildContext拡張を再エクスポートし、利用側のimportを一本化する.
library;

export 'src/route_lifecycle.dart';
export 'src/route_lifecycle_detector.dart';
export 'src/route_lifecycle_exceptions.dart';
export 'src/route_lifecycle_extensions.dart';
