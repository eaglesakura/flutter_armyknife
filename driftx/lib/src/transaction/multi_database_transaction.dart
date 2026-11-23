import 'dart:async';

import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

part 'multi_database_transaction.state.dart';

/// 複数データベースに対する同時トランザクション.
///
/// Driftの挙動として、DBトランザクションの内部で別DBのトランザクション（入れ子）が行えない.
/// この特性を回避するため、複数のデータベースに対して同時にトランザクションを行うためのクラス.
class MultiDatabaseTransactions {
  /// 対象トランザクション一覧.
  final List<_State> _transactions;

  /// [_transactions] を束ねた同時トランザクションハンドルを生成する.
  ///
  /// [transaction] からのみ生成する想定.
  MultiDatabaseTransactions._(this._transactions);

  /// 指定DBの操作を行う.
  ///
  /// [db] は [transaction] に渡した一覧に含まれる必要がある.
  /// [action] は対象DBのトランザクション内で直列実行され、完了または失敗まで待つ.
  /// 未登録の [db] を渡すと [StateError] 相当の検索失敗になる.
  ///
  /// Example:
  /// ```dart
  /// await MultiDatabaseTransactions.transaction(
  ///   [dbA, dbB],
  ///   (tx) async {
  ///     await tx.execute(dbA, (db) async {
  ///       // dbA への書き込み
  ///     });
  ///     await tx.execute(dbB, (db) async {
  ///       // dbB への書き込み
  ///     });
  ///   },
  /// );
  /// ```
  Future<T> execute<DB extends GeneratedDatabase, T>(
    DB db,
    Future<T> Function(DB db) action,
  ) async {
    // 対象を検索
    final state = _transactions.firstWhere((e) => e.database == db);

    final completer = Completer<T>();
    state.requests.add(() async {
      try {
        completer.complete(await action(db));
      } catch (e, stackTrace) {
        completer.completeError(e, stackTrace);
      }
    });
    return completer.future;
  }

  /// 複数データベースの同時トランザクションを開始する.
  ///
  /// [databases] それぞれでトランザクションを開き、準備完了後に [action] を実行する.
  /// [action] 完了後、すべてのトランザクションが成功した場合、成功した結果を返す.
  /// 1つでもDB操作が失敗した場合、すべてのDBのトランザクションがロールバックされる.
  ///
  /// Example:
  /// ```dart
  /// final value = await MultiDatabaseTransactions.transaction(
  ///   [dbA, dbB],
  ///   (tx) async {
  ///     await tx.execute(dbA, (db) async => null);
  ///     await tx.execute(dbB, (db) async => null);
  ///     return 42;
  ///   },
  /// );
  /// ```
  static Future<T> transaction<T>(
    List<GeneratedDatabase> databases,
    Future<T> Function(MultiDatabaseTransactions tx) action,
  ) async {
    final transactions = databases.map((e) => _State(e)).toList();
    final tx = MultiDatabaseTransactions._(transactions);

    // すべてのトランザクションを別zoneで実行.
    for (final transaction in transactions) {
      unawaited(transaction.execute());
    }

    late T result;

    /// トランザクションの実行
    try {
      /// すべてのトランザクションが開始されるまで待つ
      await Future.wait(transactions.map((e) => e.transactionReady.future));

      // トランザクションの処理を実行
      result = await action(tx);

      /// トランザクションの成功を通知
      for (final transaction in transactions) {
        await transaction.close(
          success: true,
        );
      }

      return result;
    } on Exception catch (_) {
      /// トランザクションの失敗を通知
      for (final transaction in transactions) {
        await transaction.close(
          success: false,
        );
      }

      rethrow;
    }
  }
}
