/// 非同期処理のキャンセル時に投げられる例外.
///
/// wait/notifyやチャネルのキャンセル経路で発生しうる.
class CancellationException implements Exception {
  /// 呼び出し元へ伝えるキャンセル理由.
  final String message;

  /// [message] を保持するキャンセル例外を作成する.
  ///
  /// Example:
  /// ```dart
  /// throw CancellationException('operation cancelled');
  /// ```
  CancellationException(this.message);

  /// デバッグ向けの文字列表現を返す.
  ///
  /// Example:
  /// ```dart
  /// final text = CancellationException('closed').toString();
  /// ```
  @override
  String toString() {
    return 'CancellationException(message: $message)';
  }
}
