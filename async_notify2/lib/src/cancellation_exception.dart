/// 非同期処理のキャンセル時に投げられる例外.
class CancellationException implements Exception {
  final String message;

  CancellationException(this.message);

  @override
  String toString() {
    return 'CancellationException(message: $message)';
  }
}
