// ignore_for_file: constant_identifier_names

/// SQLiteの結果コード
///
/// https://sqlite.org/rescode.html
enum SqliteResultCode {
  // Primary Result Codes
  /// The SQLITE_OK result code means that the operation was successful and that there were no errors.
  /// Most other result codes indicate an error.
  SQLITE_OK(0),

  /// The SQLITE_ERROR result code is a generic error code that is used when no other more specific error code is available.
  SQLITE_ERROR(1),

  /// The SQLITE_INTERNAL result code indicates an internal malfunction.
  /// In a working version of SQLite, an application should never see this result code.
  /// If application does encounter this result code, it shows that there is a bug in the database engine.
  SQLITE_INTERNAL(2),

  /// The SQLITE_PERM result code indicates that the requested access mode for a newly created database could not be provided.
  SQLITE_PERM(3),

  /// The SQLITE_ABORT result code indicates that an operation was aborted prior to completion,
  /// usually be application request.
  SQLITE_ABORT(4),

  /// The SQLITE_BUSY result code indicates that the database file could not be written (or in some cases read)
  /// because of concurrent activity by some other database connection,
  /// usually a database connection in a separate process.
  SQLITE_BUSY(5),

  /// The SQLITE_LOCKED result code indicates that a write operation could not continue because of a conflict
  /// within the same database connection or a conflict with a different database connection that uses a shared cache.
  SQLITE_LOCKED(6),

  /// The SQLITE_NOMEM result code indicates that SQLite was unable to allocate all the memory it needed to complete the operation.
  SQLITE_NOMEM(7),

  /// The SQLITE_READONLY result code is returned when an attempt is made to alter some data for which the current database connection
  /// does not have write permission.
  SQLITE_READONLY(8),

  /// The SQLITE_INTERRUPT result code indicates that an operation was interrupted by the sqlite3_interrupt() interface.
  SQLITE_INTERRUPT(9),

  /// The SQLITE_IOERR result code says that an I/O error occurred within the xRead or xWrite methods on the sqlite3_io_methods object.
  SQLITE_IOERR(10),

  /// The SQLITE_CORRUPT result code is returned when SQLite detects that the database file has been corrupted.
  SQLITE_CORRUPT(11),

  /// The SQLITE_NOTFOUND result code is returned when a requested file or directory cannot be found.
  SQLITE_NOTFOUND(12),

  /// The SQLITE_FULL result code is returned when an attempt is made to write to a database file that is too large for the filesystem.
  SQLITE_FULL(13),

  /// The SQLITE_CANTOPEN result code is returned when SQLite is unable to open a file.
  SQLITE_CANTOPEN(14),

  /// The SQLITE_PROTOCOL result code is returned when some other process is messing with file locks and has violated the file locking protocol
  /// that SQLite uses on its rollback journal files.
  SQLITE_PROTOCOL(15),

  /// The SQLITE_EMPTY result code is returned when a query that expected to return at least one row returns no rows.
  SQLITE_EMPTY(16),

  /// The SQLITE_SCHEMA result code indicates that the database schema has changed.
  SQLITE_SCHEMA(17),

  /// The SQLITE_TOOBIG result code is returned when a string or BLOB exceeds limits set by sqlite3_limit(SQLITE_LIMIT_LENGTH) or SQLITE_MAX_LENGTH.
  SQLITE_TOOBIG(18),

  /// The SQLITE_CONSTRAINT result code is returned when a constraint violation occurs.
  SQLITE_CONSTRAINT(19),

  /// The SQLITE_MISMATCH result code is returned when there is a data type mismatch.
  SQLITE_MISMATCH(20),

  /// The SQLITE_MISUSE result code is returned when the application uses any SQLite interface in a way that is undefined or unsupported.
  SQLITE_MISUSE(21),

  /// The SQLITE_NOLFS result code is returned when the operating system does not support large files.
  SQLITE_NOLFS(22),

  /// The SQLITE_AUTH result code is returned when authorization is denied.
  SQLITE_AUTH(23),

  /// The SQLITE_FORMAT result code is returned when the database file format is invalid.
  SQLITE_FORMAT(24),

  /// The SQLITE_RANGE result code is returned when a parameter or column index is out of range.
  SQLITE_RANGE(25),

  /// The SQLITE_NOTADB result code is returned when a file that is purported to be a database file is not actually a database file.
  SQLITE_NOTADB(26),

  /// The SQLITE_NOTICE result code is returned when SQLite wants to report some non-fatal condition.
  SQLITE_NOTICE(27),

  /// The SQLITE_WARNING result code is returned when SQLite wants to report some warning condition.
  SQLITE_WARNING(28),

  /// The SQLITE_ROW result code is returned by sqlite3_step() each time a new row of data is ready for processing by the caller.
  SQLITE_ROW(100),

  /// The SQLITE_DONE result code is returned by sqlite3_step() when the statement has finished executing successfully.
  SQLITE_DONE(101),

  // Extended Result Codes
  /// The SQLITE_ABORT_ROLLBACK error code is an extended error code for SQLITE_ABORT indicating that the transaction was rolled back.
  SQLITE_ABORT_ROLLBACK(516),

  /// The SQLITE_AUTH_USER error code is an extended error code for SQLITE_AUTH indicating that the user is not authorized to perform the operation.
  SQLITE_AUTH_USER(279),

  /// The SQLITE_BUSY_RECOVERY error code is an extended error code for SQLITE_BUSY indicating that the database is in recovery mode.
  SQLITE_BUSY_RECOVERY(261),

  /// The SQLITE_BUSY_SNAPSHOT error code is an extended error code for SQLITE_BUSY indicating that the database is in snapshot mode.
  SQLITE_BUSY_SNAPSHOT(517),

  /// The SQLITE_BUSY_TIMEOUT error code is an extended error code for SQLITE_BUSY indicating that the operation timed out.
  SQLITE_BUSY_TIMEOUT(773),

  /// The SQLITE_CANTOPEN_CONVPATH error code is an extended error code for SQLITE_CANTOPEN indicating that the path conversion failed.
  SQLITE_CANTOPEN_CONVPATH(1038),

  /// The SQLITE_CANTOPEN_DIRTYWAL error code is an extended error code for SQLITE_CANTOPEN indicating that the WAL file is dirty.
  SQLITE_CANTOPEN_DIRTYWAL(1294),

  /// The SQLITE_CANTOPEN_FULLPATH error code is an extended error code for SQLITE_CANTOPEN indicating that the full path could not be obtained.
  SQLITE_CANTOPEN_FULLPATH(782),

  /// The SQLITE_CANTOPEN_ISDIR error code is an extended error code for SQLITE_CANTOPEN indicating that the path is a directory.
  SQLITE_CANTOPEN_ISDIR(526),

  /// The SQLITE_CANTOPEN_NOTEMPDIR error code is an extended error code for SQLITE_CANTOPEN indicating that the temporary directory could not be created.
  SQLITE_CANTOPEN_NOTEMPDIR(270),

  /// The SQLITE_CANTOPEN_SYMLINK error code is an extended error code for SQLITE_CANTOPEN indicating that the path is a symbolic link.
  SQLITE_CANTOPEN_SYMLINK(1550),

  /// The SQLITE_CONSTRAINT_CHECK error code is an extended error code for SQLITE_CONSTRAINT indicating that a CHECK constraint failed.
  SQLITE_CONSTRAINT_CHECK(275),

  /// The SQLITE_CONSTRAINT_COMMITHOOK error code is an extended error code for SQLITE_CONSTRAINT indicating that a commit hook failed.
  SQLITE_CONSTRAINT_COMMITHOOK(531),

  /// The SQLITE_CONSTRAINT_DATATYPE error code is an extended error code for SQLITE_CONSTRAINT indicating that a data type constraint failed.
  SQLITE_CONSTRAINT_DATATYPE(3091),

  /// The SQLITE_CONSTRAINT_FOREIGNKEY error code is an extended error code for SQLITE_CONSTRAINT indicating that a foreign key constraint failed.
  SQLITE_CONSTRAINT_FOREIGNKEY(787),

  /// The SQLITE_CONSTRAINT_FUNCTION error code is an extended error code for SQLITE_CONSTRAINT indicating that a function constraint failed.
  SQLITE_CONSTRAINT_FUNCTION(1043),

  /// The SQLITE_CONSTRAINT_NOTNULL error code is an extended error code for SQLITE_CONSTRAINT indicating that a NOT NULL constraint failed.
  SQLITE_CONSTRAINT_NOTNULL(1299),

  /// The SQLITE_CONSTRAINT_PINNED error code is an extended error code for SQLITE_CONSTRAINT indicating that a pinned constraint failed.
  SQLITE_CONSTRAINT_PINNED(2835),

  /// The SQLITE_CONSTRAINT_PRIMARYKEY error code is an extended error code for SQLITE_CONSTRAINT indicating that a PRIMARY KEY constraint failed.
  SQLITE_CONSTRAINT_PRIMARYKEY(1555),

  /// The SQLITE_CONSTRAINT_ROWID error code is an extended error code for SQLITE_CONSTRAINT indicating that a ROWID constraint failed.
  SQLITE_CONSTRAINT_ROWID(2579),

  /// The SQLITE_CONSTRAINT_TRIGGER error code is an extended error code for SQLITE_CONSTRAINT indicating that a trigger constraint failed.
  SQLITE_CONSTRAINT_TRIGGER(1811),

  /// The SQLITE_CONSTRAINT_UNIQUE error code is an extended error code for SQLITE_CONSTRAINT indicating that a UNIQUE constraint failed.
  SQLITE_CONSTRAINT_UNIQUE(2067),

  /// The SQLITE_CONSTRAINT_VTAB error code is an extended error code for SQLITE_CONSTRAINT indicating that a virtual table constraint failed.
  SQLITE_CONSTRAINT_VTAB(2323),

  /// The SQLITE_CORRUPT_INDEX error code is an extended error code for SQLITE_CORRUPT indicating that an index is corrupt.
  SQLITE_CORRUPT_INDEX(779),

  /// The SQLITE_CORRUPT_SEQUENCE error code is an extended error code for SQLITE_CORRUPT indicating that a sequence is corrupt.
  SQLITE_CORRUPT_SEQUENCE(523),

  /// The SQLITE_CORRUPT_VTAB error code is an extended error code for SQLITE_CORRUPT indicating that a virtual table is corrupt.
  SQLITE_CORRUPT_VTAB(267),

  /// The SQLITE_ERROR_MISSING_COLLSEQ error code is an extended error code for SQLITE_ERROR indicating that a collating sequence is missing.
  SQLITE_ERROR_MISSING_COLLSEQ(257),

  /// The SQLITE_ERROR_RETRY error code is an extended error code for SQLITE_ERROR indicating that the operation should be retried.
  SQLITE_ERROR_RETRY(513),

  /// The SQLITE_ERROR_SNAPSHOT error code is an extended error code for SQLITE_ERROR indicating that a snapshot is invalid.
  SQLITE_ERROR_SNAPSHOT(769),

  /// The SQLITE_IOERR_ACCESS error code is an extended error code for SQLITE_IOERR indicating that an access error occurred.
  SQLITE_IOERR_ACCESS(3338),

  /// The SQLITE_IOERR_AUTH error code is an extended error code for SQLITE_IOERR indicating that an authentication error occurred.
  SQLITE_IOERR_AUTH(7178),

  /// The SQLITE_IOERR_BEGIN_ATOMIC error code is an extended error code for SQLITE_IOERR indicating that a begin atomic operation failed.
  SQLITE_IOERR_BEGIN_ATOMIC(7434),

  /// The SQLITE_IOERR_BLOCKED error code is an extended error code for SQLITE_IOERR indicating that the operation was blocked.
  SQLITE_IOERR_BLOCKED(2826),

  /// The SQLITE_IOERR_CHECKRESERVEDLOCK error code is an extended error code for SQLITE_IOERR indicating that a check reserved lock failed.
  SQLITE_IOERR_CHECKRESERVEDLOCK(3594),

  /// The SQLITE_IOERR_CLOSE error code is an extended error code for SQLITE_IOERR indicating that a close operation failed.
  SQLITE_IOERR_CLOSE(4106),

  /// The SQLITE_IOERR_COMMIT_ATOMIC error code is an extended error code for SQLITE_IOERR indicating that a commit atomic operation failed.
  SQLITE_IOERR_COMMIT_ATOMIC(7690),

  /// The SQLITE_IOERR_CONVPATH error code is an extended error code for SQLITE_IOERR indicating that a path conversion failed.
  SQLITE_IOERR_CONVPATH(6666),

  /// The SQLITE_IOERR_CORRUPTFS error code is an extended error code for SQLITE_IOERR indicating that the filesystem is corrupt.
  SQLITE_IOERR_CORRUPTFS(8458),

  /// The SQLITE_IOERR_DATA error code is an extended error code for SQLITE_IOERR indicating that a data error occurred.
  SQLITE_IOERR_DATA(8202),

  /// The SQLITE_IOERR_DELETE error code is an extended error code for SQLITE_IOERR indicating that a delete operation failed.
  SQLITE_IOERR_DELETE(2570),

  /// The SQLITE_IOERR_DELETE_NOENT error code is an extended error code for SQLITE_IOERR indicating that a delete operation failed because the file does not exist.
  SQLITE_IOERR_DELETE_NOENT(5898),

  /// The SQLITE_IOERR_DIR_CLOSE error code is an extended error code for SQLITE_IOERR indicating that a directory close operation failed.
  SQLITE_IOERR_DIR_CLOSE(4362),

  /// The SQLITE_IOERR_DIR_FSYNC error code is an extended error code for SQLITE_IOERR indicating that a directory fsync operation failed.
  SQLITE_IOERR_DIR_FSYNC(1290),

  /// The SQLITE_IOERR_FSTAT error code is an extended error code for SQLITE_IOERR indicating that a fstat operation failed.
  SQLITE_IOERR_FSTAT(1802),

  /// The SQLITE_IOERR_FSYNC error code is an extended error code for SQLITE_IOERR indicating that a fsync operation failed.
  SQLITE_IOERR_FSYNC(1034),

  /// The SQLITE_IOERR_GETTEMPPATH error code is an extended error code for SQLITE_IOERR indicating that a get temporary path operation failed.
  SQLITE_IOERR_GETTEMPPATH(6410),

  /// The SQLITE_IOERR_LOCK error code is an extended error code for SQLITE_IOERR indicating that a lock operation failed.
  SQLITE_IOERR_LOCK(3850),

  /// The SQLITE_IOERR_MMAP error code is an extended error code for SQLITE_IOERR indicating that a memory mapping operation failed.
  SQLITE_IOERR_MMAP(6154),

  /// The SQLITE_IOERR_NOMEM error code is an extended error code for SQLITE_IOERR indicating that a memory allocation operation failed.
  SQLITE_IOERR_NOMEM(3082),

  /// The SQLITE_IOERR_RDLOCK error code is an extended error code for SQLITE_IOERR indicating that a read lock operation failed.
  SQLITE_IOERR_RDLOCK(2314),

  /// The SQLITE_IOERR_READ error code is an extended error code for SQLITE_IOERR indicating that a read operation failed.
  SQLITE_IOERR_READ(266),

  /// The SQLITE_IOERR_ROLLBACK_ATOMIC error code is an extended error code for SQLITE_IOERR indicating that a rollback atomic operation failed.
  SQLITE_IOERR_ROLLBACK_ATOMIC(7946),

  /// The SQLITE_IOERR_SEEK error code is an extended error code for SQLITE_IOERR indicating that a seek operation failed.
  SQLITE_IOERR_SEEK(5642),

  /// The SQLITE_IOERR_SHMLOCK error code is an extended error code for SQLITE_IOERR indicating that a shared memory lock operation failed.
  SQLITE_IOERR_SHMLOCK(5130),

  /// The SQLITE_IOERR_SHMMAP error code is an extended error code for SQLITE_IOERR indicating that a shared memory mapping operation failed.
  SQLITE_IOERR_SHMMAP(5386),

  /// The SQLITE_IOERR_SHMOPEN error code is an extended error code for SQLITE_IOERR indicating that a shared memory open operation failed.
  SQLITE_IOERR_SHMOPEN(4618),

  /// The SQLITE_IOERR_SHMSIZE error code is an extended error code for SQLITE_IOERR indicating that a shared memory size operation failed.
  SQLITE_IOERR_SHMSIZE(4874),

  /// The SQLITE_IOERR_SHORT_READ error code is an extended error code for SQLITE_IOERR indicating that a short read operation occurred.
  SQLITE_IOERR_SHORT_READ(522),

  /// The SQLITE_IOERR_TRUNCATE error code is an extended error code for SQLITE_IOERR indicating that a truncate operation failed.
  SQLITE_IOERR_TRUNCATE(1546),

  /// The SQLITE_IOERR_UNLOCK error code is an extended error code for SQLITE_IOERR indicating that an unlock operation failed.
  SQLITE_IOERR_UNLOCK(2058),

  /// The SQLITE_IOERR_VNODE error code is an extended error code for SQLITE_IOERR indicating that a virtual node operation failed.
  SQLITE_IOERR_VNODE(6922),

  /// The SQLITE_IOERR_WRITE error code is an extended error code for SQLITE_IOERR indicating that a write operation failed.
  SQLITE_IOERR_WRITE(778),

  /// The SQLITE_LOCKED_SHAREDCACHE error code is an extended error code for SQLITE_LOCKED indicating that a shared cache lock failed.
  SQLITE_LOCKED_SHAREDCACHE(262),

  /// The SQLITE_LOCKED_VTAB error code is an extended error code for SQLITE_LOCKED indicating that a virtual table lock failed.
  SQLITE_LOCKED_VTAB(518),

  /// The SQLITE_NOTICE_RECOVER_ROLLBACK error code is an extended error code for SQLITE_NOTICE indicating that a rollback recovery occurred.
  SQLITE_NOTICE_RECOVER_ROLLBACK(539),

  /// The SQLITE_NOTICE_RECOVER_WAL error code is an extended error code for SQLITE_NOTICE indicating that a WAL recovery occurred.
  SQLITE_NOTICE_RECOVER_WAL(283),

  /// The SQLITE_OK_LOAD_PERMANENTLY error code is an extended error code for SQLITE_OK indicating that a load permanently operation succeeded.
  SQLITE_OK_LOAD_PERMANENTLY(256),

  /// The SQLITE_READONLY_CANTINIT error code is an extended error code for SQLITE_READONLY indicating that a cant init operation failed.
  SQLITE_READONLY_CANTINIT(1288),

  /// The SQLITE_READONLY_CANTLOCK error code is an extended error code for SQLITE_READONLY indicating that a cant lock operation failed.
  SQLITE_READONLY_CANTLOCK(520),

  /// The SQLITE_READONLY_DBMOVED error code is an extended error code for SQLITE_READONLY indicating that a database moved operation failed.
  SQLITE_READONLY_DBMOVED(1032),

  /// The SQLITE_READONLY_DIRECTORY error code is an extended error code for SQLITE_READONLY indicating that a directory operation failed.
  SQLITE_READONLY_DIRECTORY(1544),

  /// The SQLITE_READONLY_RECOVERY error code is an extended error code for SQLITE_READONLY indicating that a recovery operation failed.
  SQLITE_READONLY_RECOVERY(264),

  /// The SQLITE_READONLY_ROLLBACK error code is an extended error code for SQLITE_READONLY indicating that a rollback operation failed.
  SQLITE_READONLY_ROLLBACK(776),

  /// The SQLITE_WARNING_AUTOINDEX error code is an extended error code for SQLITE_WARNING indicating that an autoindex warning occurred.
  SQLITE_WARNING_AUTOINDEX(284);

  final int code;

  const SqliteResultCode(this.code);

  factory SqliteResultCode.fromCode(int code) {
    return values.firstWhere((element) => element.code == code);
  }
}
