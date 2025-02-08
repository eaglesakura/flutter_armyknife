part of 'multi_database_transaction.dart';

/// Driftで生成されたデータベースのトランザクション対象
class _State {
  /// DB.
  final GeneratedDatabase database;

  final transactionReady = Completer();

  final transactionDone = Completer();

  final requests = PublishSubject<Future Function()>();

  /// すべての処理が成功している場合true.
  var _success = false;

  _State(this.database);

  /// トランザクションの終了を通知する
  Future close({
    required bool success,
  }) async {
    _success = success;
    await requests.close();
  }

  /// トランザクションを開始する
  Future execute() async {
    try {
      await database.transaction(() async {
        // トランザクション開始を通知
        transactionReady.complete();

        // コールバックに対応
        await for (final callback in requests) {
          await callback();
        }

        if (_success) {
          return;
        } else {
          throw Exception('Transaction failed');
        }
      });
    } on Exception catch (e, stackTrace) {
      // トランザクション開始まで終わってない
      if (!transactionReady.isCompleted) {
        transactionReady.completeError(e, stackTrace);
        return;
      }
    } finally {
      transactionDone.complete();
    }
  }
}
