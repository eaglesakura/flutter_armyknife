part of 'multi_database_transaction.dart';

/// Driftで生成されたデータベースのトランザクション対象.
///
/// 1つの [GeneratedDatabase] につき1インスタンスを持ち、
/// トランザクション開始・リクエスト直列実行・成否に応じたcommit/rollbackを担当する.
class _State {
  /// 対象DB.
  final GeneratedDatabase database;

  /// トランザクション開始完了を待つCompleter.
  ///
  /// [execute] 内で `database.transaction` に入った時点でcompleteする.
  /// 開始前に失敗した場合はcompleteErrorする.
  final transactionReady = Completer();

  /// トランザクション処理全体の終了を待つCompleter.
  ///
  /// commit/rollbackの成否にかかわらず、finallyでcompleteする.
  final transactionDone = Completer();

  /// トランザクション内で直列実行するリクエストキュー.
  ///
  /// [MultiDatabaseTransactions.execute] がコールバックを流し込み、
  /// [close] で閉じると待機ループが終了する.
  final requests = PublishSubject<Future Function()>();

  /// すべての処理が成功している場合true.
  ///
  /// [close] で設定し、falseのときは意図的に例外を投げてrollbackさせる.
  var _success = false;

  /// [database] 向けのトランザクション状態を生成する.
  ///
  /// Example:
  /// ```dart
  /// // MultiDatabaseTransactions.transaction 内部で生成される
  /// final state = _State(database);
  /// ```
  _State(this.database);

  /// トランザクションの終了を通知する.
  ///
  /// [success] がtrueならcommit、falseならrollbackへ誘導する.
  /// [requests] を閉じ、待機中の直列実行ループを終わらせる.
  ///
  /// Example:
  /// ```dart
  /// await state.close(success: true);
  /// ```
  Future close({
    required bool success,
  }) async {
    _success = success;
    await requests.close();
  }

  /// トランザクションを開始する.
  ///
  /// [transactionReady] を完了させたあと、[requests] のコールバックを順に実行する.
  /// [_success] がfalseなら例外を投げ、Drift側でrollbackさせる.
  /// 開始前失敗時は [transactionReady] をcompleteErrorし、常に [transactionDone] を完了する.
  ///
  /// Example:
  /// ```dart
  /// // MultiDatabaseTransactions.transaction から unawaited で起動される
  /// unawaited(state.execute());
  /// ```
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
