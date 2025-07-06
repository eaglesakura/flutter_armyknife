Drift ライブラリの便利機能を提供するパッケージです。SQLite 結果コードの型安全な処理と、複数データベースの同時トランザクション機能を提供します。

## Features

- **SQLite 結果コードの列挙型**: SQLite 公式の結果コードを完全に網羅した型安全な列挙型
- **複数データベースの同時トランザクション**: Drift の制約を回避し、複数のデータベースに対する同時トランザクション実行

## Getting started

pubspec.yaml に以下を追加してください：

```yaml
dependencies:
  armyknife_driftx: ^1.0.0
```

## Usage

### SQLite 結果コードの使用

```dart
import 'package:armyknife_driftx/armyknife_driftx.dart';

// SQLite結果コードの型安全な処理
void handleSqliteResult(int code) {
  final resultCode = SqliteResultCode.fromCode(code);

  switch (resultCode) {
    case SqliteResultCode.SQLITE_OK:
      // 成功時の処理
      print('操作が成功しました');
      break;
    case SqliteResultCode.SQLITE_CONSTRAINT:
      // 制約違反時の処理
      print('制約違反エラーが発生しました');
      break;
    case SqliteResultCode.SQLITE_BUSY:
      // データベースがビジー状態
      print('データベースがビジー状態です');
      break;
    case SqliteResultCode.SQLITE_CORRUPT:
      // データベースファイルが破損
      print('データベースファイルが破損しています');
      break;
    default:
      // その他のエラー
      print('SQLiteエラー: ${resultCode.code}');
  }
}
```

### 複数データベースの同時トランザクション

```dart
import 'package:armyknife_driftx/armyknife_driftx.dart';

// 複数データベースの同時トランザクション
final result = await MultiDatabaseTransactions.transaction(
  [database1, database2, database3],
  (tx) async {
    // database1への操作
    await tx.execute(database1, (db) async {
      await db.insert(table1).insert(data1);
    });

    // database2への操作
    await tx.execute(database2, (db) async {
      await db.insert(table2).insert(data2);
    });

    // database3への操作
    await tx.execute(database3, (db) async {
      await db.insert(table3).insert(data3);
    });

    return 'success';
  },
);
```

## Additional information

このパッケージは Drift ライブラリの制約を回避し、より柔軟なデータベース操作を可能にします。複数データベースの同時トランザクションでは、すべての操作が成功した場合のみコミットされ、1 つでも失敗した場合は全てがロールバックされます。
