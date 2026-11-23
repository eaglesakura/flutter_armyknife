// ignore_for_file: constant_identifier_names

/// SQLiteの結果コード.
///
/// https://sqlite.org/rescode.html のPrimary/Extended結果コードを列挙する.
/// Driftやnative層から返る数値コードを型付きで扱うために使う.
enum SqliteResultCode {
  // Primary Result Codes
  /// 操作が成功し、エラーがなかったことを示す結果コード.
  /// 多くの他コードは何らかのエラーを表す.
  SQLITE_OK(0),

  /// より具体的なコードが無いときの汎用エラーコード.
  SQLITE_ERROR(1),

  /// SQLite内部の不具合を示す結果コード.
  /// 正常なSQLiteではアプリが通常見ないコードであり、遭遇時はエンジン側のバグを疑う.
  SQLITE_INTERNAL(2),

  /// 新規作成DBに要求したアクセスモードを提供できなかったことを示す.
  SQLITE_PERM(3),

  /// 完了前に操作が中断されたことを示す結果コード.
  /// 多くの場合はアプリ側の要求による.
  SQLITE_ABORT(4),

  /// 別接続（多くは別プロセス）の同時活動により、DBファイルへ書けなかった（または読めなかった）ことを示す.
  SQLITE_BUSY(5),

  /// 同一接続内の競合、または共有キャッシュを使う別接続との競合により、書き込みを続けられなかったことを示す.
  SQLITE_LOCKED(6),

  /// 操作完了に必要なメモリをSQLiteが確保できなかったことを示す.
  SQLITE_NOMEM(7),

  /// 書き込み権限の無いデータへ変更を試みたことを示す.
  SQLITE_READONLY(8),

  /// `sqlite3_interrupt()` により操作が中断されたことを示す.
  SQLITE_INTERRUPT(9),

  /// `sqlite3_io_methods` のxRead/xWrite内でI/Oエラーが起きたことを示す.
  SQLITE_IOERR(10),

  /// DBファイルの破損をSQLiteが検出したことを示す.
  SQLITE_CORRUPT(11),

  /// 要求したファイルまたはディレクトリが見つからないことを示す.
  SQLITE_NOTFOUND(12),

  /// ファイルシステム上限を超える大きさのDBへ書き込もうとしたことを示す.
  SQLITE_FULL(13),

  /// ファイルを開けなかったことを示す.
  SQLITE_CANTOPEN(14),

  /// 他プロセスがファイルロックを乱し、ロールバックジャーナルのロック規約に違反したことを示す.
  SQLITE_PROTOCOL(15),

  /// 1行以上を期待するクエリが行を返さなかったことを示す.
  SQLITE_EMPTY(16),

  /// DBスキーマが変化したことを示す.
  SQLITE_SCHEMA(17),

  /// 文字列またはBLOBが `sqlite3_limit(SQLITE_LIMIT_LENGTH)` や `SQLITE_MAX_LENGTH` の上限を超えたことを示す.
  SQLITE_TOOBIG(18),

  /// 制約違反が起きたことを示す.
  SQLITE_CONSTRAINT(19),

  /// データ型の不一致が起きたことを示す.
  SQLITE_MISMATCH(20),

  /// 未定義または非対応な使い方でSQLiteインタフェースを呼んだことを示す.
  SQLITE_MISUSE(21),

  /// OSが大きなファイルをサポートしていないことを示す.
  SQLITE_NOLFS(22),

  /// 認可が拒否されたことを示す.
  SQLITE_AUTH(23),

  /// DBファイル形式が不正であることを示す.
  SQLITE_FORMAT(24),

  /// パラメータまたは列インデックスが範囲外であることを示す.
  SQLITE_RANGE(25),

  /// DBファイルだとされたファイルが実際にはDBではないことを示す.
  SQLITE_NOTADB(26),

  /// 致命的ではない状態を報告するための結果コード.
  SQLITE_NOTICE(27),

  /// 警告状態を報告するための結果コード.
  SQLITE_WARNING(28),

  /// `sqlite3_step()` が新しい行を呼び出し側の処理待ちにしたことを示す.
  SQLITE_ROW(100),

  /// `sqlite3_step()` が文の実行を正常に終えたことを示す.
  SQLITE_DONE(101),

  // Extended Result Codes
  /// [SQLITE_ABORT] の拡張コード. トランザクションがロールバックされたことを示す.
  SQLITE_ABORT_ROLLBACK(516),

  /// [SQLITE_AUTH] の拡張コード. ユーザーが操作を認可されていないことを示す.
  SQLITE_AUTH_USER(279),

  /// [SQLITE_BUSY] の拡張コード. DBがリカバリ中であることを示す.
  SQLITE_BUSY_RECOVERY(261),

  /// [SQLITE_BUSY] の拡張コード. DBがスナップショットモードであることを示す.
  SQLITE_BUSY_SNAPSHOT(517),

  /// [SQLITE_BUSY] の拡張コード. 操作がタイムアウトしたことを示す.
  SQLITE_BUSY_TIMEOUT(773),

  /// [SQLITE_CANTOPEN] の拡張コード. パス変換に失敗したことを示す.
  SQLITE_CANTOPEN_CONVPATH(1038),

  /// [SQLITE_CANTOPEN] の拡張コード. WALファイルがdirtyであることを示す.
  SQLITE_CANTOPEN_DIRTYWAL(1294),

  /// [SQLITE_CANTOPEN] の拡張コード. フルパスを取得できなかったことを示す.
  SQLITE_CANTOPEN_FULLPATH(782),

  /// [SQLITE_CANTOPEN] の拡張コード. パスがディレクトリであることを示す.
  SQLITE_CANTOPEN_ISDIR(526),

  /// [SQLITE_CANTOPEN] の拡張コード. 一時ディレクトリを作成できなかったことを示す.
  SQLITE_CANTOPEN_NOTEMPDIR(270),

  /// [SQLITE_CANTOPEN] の拡張コード. パスがシンボリックリンクであることを示す.
  SQLITE_CANTOPEN_SYMLINK(1550),

  /// [SQLITE_CONSTRAINT] の拡張コード. CHECK制約違反を示す.
  SQLITE_CONSTRAINT_CHECK(275),

  /// [SQLITE_CONSTRAINT] の拡張コード. commit hookの失敗を示す.
  SQLITE_CONSTRAINT_COMMITHOOK(531),

  /// [SQLITE_CONSTRAINT] の拡張コード. データ型制約違反を示す.
  SQLITE_CONSTRAINT_DATATYPE(3091),

  /// [SQLITE_CONSTRAINT] の拡張コード. 外部キー制約違反を示す.
  SQLITE_CONSTRAINT_FOREIGNKEY(787),

  /// [SQLITE_CONSTRAINT] の拡張コード. 関数制約違反を示す.
  SQLITE_CONSTRAINT_FUNCTION(1043),

  /// [SQLITE_CONSTRAINT] の拡張コード. NOT NULL制約違反を示す.
  SQLITE_CONSTRAINT_NOTNULL(1299),

  /// [SQLITE_CONSTRAINT] の拡張コード. pinned制約違反を示す.
  SQLITE_CONSTRAINT_PINNED(2835),

  /// [SQLITE_CONSTRAINT] の拡張コード. PRIMARY KEY制約違反を示す.
  SQLITE_CONSTRAINT_PRIMARYKEY(1555),

  /// [SQLITE_CONSTRAINT] の拡張コード. ROWID制約違反を示す.
  SQLITE_CONSTRAINT_ROWID(2579),

  /// [SQLITE_CONSTRAINT] の拡張コード. トリガー制約違反を示す.
  SQLITE_CONSTRAINT_TRIGGER(1811),

  /// [SQLITE_CONSTRAINT] の拡張コード. UNIQUE制約違反を示す.
  SQLITE_CONSTRAINT_UNIQUE(2067),

  /// [SQLITE_CONSTRAINT] の拡張コード. 仮想テーブル制約違反を示す.
  SQLITE_CONSTRAINT_VTAB(2323),

  /// [SQLITE_CORRUPT] の拡張コード. インデックス破損を示す.
  SQLITE_CORRUPT_INDEX(779),

  /// [SQLITE_CORRUPT] の拡張コード. シーケンス破損を示す.
  SQLITE_CORRUPT_SEQUENCE(523),

  /// [SQLITE_CORRUPT] の拡張コード. 仮想テーブル破損を示す.
  SQLITE_CORRUPT_VTAB(267),

  /// [SQLITE_ERROR] の拡張コード. 照合順序が欠けていることを示す.
  SQLITE_ERROR_MISSING_COLLSEQ(257),

  /// [SQLITE_ERROR] の拡張コード. 操作の再試行が必要なことを示す.
  SQLITE_ERROR_RETRY(513),

  /// [SQLITE_ERROR] の拡張コード. スナップショットが無効であることを示す.
  SQLITE_ERROR_SNAPSHOT(769),

  /// [SQLITE_IOERR] の拡張コード. アクセスエラーを示す.
  SQLITE_IOERR_ACCESS(3338),

  /// [SQLITE_IOERR] の拡張コード. 認証エラーを示す.
  SQLITE_IOERR_AUTH(7178),

  /// [SQLITE_IOERR] の拡張コード. begin atomic操作の失敗を示す.
  SQLITE_IOERR_BEGIN_ATOMIC(7434),

  /// [SQLITE_IOERR] の拡張コード. 操作がブロックされたことを示す.
  SQLITE_IOERR_BLOCKED(2826),

  /// [SQLITE_IOERR] の拡張コード. reserved lock確認の失敗を示す.
  SQLITE_IOERR_CHECKRESERVEDLOCK(3594),

  /// [SQLITE_IOERR] の拡張コード. close操作の失敗を示す.
  SQLITE_IOERR_CLOSE(4106),

  /// [SQLITE_IOERR] の拡張コード. commit atomic操作の失敗を示す.
  SQLITE_IOERR_COMMIT_ATOMIC(7690),

  /// [SQLITE_IOERR] の拡張コード. パス変換の失敗を示す.
  SQLITE_IOERR_CONVPATH(6666),

  /// [SQLITE_IOERR] の拡張コード. ファイルシステム破損を示す.
  SQLITE_IOERR_CORRUPTFS(8458),

  /// [SQLITE_IOERR] の拡張コード. データエラーを示す.
  SQLITE_IOERR_DATA(8202),

  /// [SQLITE_IOERR] の拡張コード. 削除操作の失敗を示す.
  SQLITE_IOERR_DELETE(2570),

  /// [SQLITE_IOERR] の拡張コード. 対象ファイルが無く削除に失敗したことを示す.
  SQLITE_IOERR_DELETE_NOENT(5898),

  /// [SQLITE_IOERR] の拡張コード. ディレクトリcloseの失敗を示す.
  SQLITE_IOERR_DIR_CLOSE(4362),

  /// [SQLITE_IOERR] の拡張コード. ディレクトリfsyncの失敗を示す.
  SQLITE_IOERR_DIR_FSYNC(1290),

  /// [SQLITE_IOERR] の拡張コード. fstat操作の失敗を示す.
  SQLITE_IOERR_FSTAT(1802),

  /// [SQLITE_IOERR] の拡張コード. fsync操作の失敗を示す.
  SQLITE_IOERR_FSYNC(1034),

  /// [SQLITE_IOERR] の拡張コード. 一時パス取得の失敗を示す.
  SQLITE_IOERR_GETTEMPPATH(6410),

  /// [SQLITE_IOERR] の拡張コード. ロック操作の失敗を示す.
  SQLITE_IOERR_LOCK(3850),

  /// [SQLITE_IOERR] の拡張コード. メモリマップ操作の失敗を示す.
  SQLITE_IOERR_MMAP(6154),

  /// [SQLITE_IOERR] の拡張コード. メモリ確保の失敗を示す.
  SQLITE_IOERR_NOMEM(3082),

  /// [SQLITE_IOERR] の拡張コード. 読み取りロックの失敗を示す.
  SQLITE_IOERR_RDLOCK(2314),

  /// [SQLITE_IOERR] の拡張コード. 読み取り操作の失敗を示す.
  SQLITE_IOERR_READ(266),

  /// [SQLITE_IOERR] の拡張コード. rollback atomic操作の失敗を示す.
  SQLITE_IOERR_ROLLBACK_ATOMIC(7946),

  /// [SQLITE_IOERR] の拡張コード. seek操作の失敗を示す.
  SQLITE_IOERR_SEEK(5642),

  /// [SQLITE_IOERR] の拡張コード. 共有メモリロックの失敗を示す.
  SQLITE_IOERR_SHMLOCK(5130),

  /// [SQLITE_IOERR] の拡張コード. 共有メモリマップの失敗を示す.
  SQLITE_IOERR_SHMMAP(5386),

  /// [SQLITE_IOERR] の拡張コード. 共有メモリopenの失敗を示す.
  SQLITE_IOERR_SHMOPEN(4618),

  /// [SQLITE_IOERR] の拡張コード. 共有メモリサイズ変更の失敗を示す.
  SQLITE_IOERR_SHMSIZE(4874),

  /// [SQLITE_IOERR] の拡張コード. short readが起きたことを示す.
  SQLITE_IOERR_SHORT_READ(522),

  /// [SQLITE_IOERR] の拡張コード. truncate操作の失敗を示す.
  SQLITE_IOERR_TRUNCATE(1546),

  /// [SQLITE_IOERR] の拡張コード. unlock操作の失敗を示す.
  SQLITE_IOERR_UNLOCK(2058),

  /// [SQLITE_IOERR] の拡張コード. 仮想ノード操作の失敗を示す.
  SQLITE_IOERR_VNODE(6922),

  /// [SQLITE_IOERR] の拡張コード. 書き込み操作の失敗を示す.
  SQLITE_IOERR_WRITE(778),

  /// [SQLITE_LOCKED] の拡張コード. 共有キャッシュロックの失敗を示す.
  SQLITE_LOCKED_SHAREDCACHE(262),

  /// [SQLITE_LOCKED] の拡張コード. 仮想テーブルロックの失敗を示す.
  SQLITE_LOCKED_VTAB(518),

  /// [SQLITE_NOTICE] の拡張コード. ロールバックリカバリが起きたことを示す.
  SQLITE_NOTICE_RECOVER_ROLLBACK(539),

  /// [SQLITE_NOTICE] の拡張コード. WALリカバリが起きたことを示す.
  SQLITE_NOTICE_RECOVER_WAL(283),

  /// [SQLITE_OK] の拡張コード. load permanently操作が成功したことを示す.
  SQLITE_OK_LOAD_PERMANENTLY(256),

  /// [SQLITE_READONLY] の拡張コード. 初期化不能による読み取り専用を示す.
  SQLITE_READONLY_CANTINIT(1288),

  /// [SQLITE_READONLY] の拡張コード. ロック不能による読み取り専用を示す.
  SQLITE_READONLY_CANTLOCK(520),

  /// [SQLITE_READONLY] の拡張コード. DB移動による読み取り専用を示す.
  SQLITE_READONLY_DBMOVED(1032),

  /// [SQLITE_READONLY] の拡張コード. ディレクトリ関連の読み取り専用を示す.
  SQLITE_READONLY_DIRECTORY(1544),

  /// [SQLITE_READONLY] の拡張コード. リカバリ関連の読み取り専用を示す.
  SQLITE_READONLY_RECOVERY(264),

  /// [SQLITE_READONLY] の拡張コード. ロールバック関連の読み取り専用を示す.
  SQLITE_READONLY_ROLLBACK(776),

  /// [SQLITE_WARNING] の拡張コード. autoindex警告を示す.
  SQLITE_WARNING_AUTOINDEX(284);

  /// SQLiteが返す数値コード.
  final int code;

  /// [code] を持つ結果コード値を定義する.
  const SqliteResultCode(this.code);

  /// 数値 [code] から対応する結果コードを返す.
  ///
  /// 一致する値が無い場合は [StateError] を投げる.
  ///
  /// Example:
  /// ```dart
  /// final result = SqliteResultCode.fromCode(0);
  /// assert(result == SqliteResultCode.SQLITE_OK);
  /// ```
  factory SqliteResultCode.fromCode(int code) {
    return values.firstWhere((element) => element.code == code);
  }
}
