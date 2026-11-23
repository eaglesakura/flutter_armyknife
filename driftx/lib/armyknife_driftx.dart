/// Drift向けの拡張ユーティリティを集約する.
///
/// SQLite結果コードと複数DB同時トランザクションを再エクスポートし、利用側のimportを一本化する.
library;

export 'src/sqlite/sqlite_result_code.dart';
export 'src/transaction/multi_database_transaction.dart';
