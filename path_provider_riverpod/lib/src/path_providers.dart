import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

/// path_provider ライブラリの取得内容をProviderとして同期的に取得する.
class PathProviders {
  const PathProviders._();

  /// Path to a directory where the application may place application-specific
  /// cache files.
  ///
  /// If this directory does not exist, it is created automatically.
  ///
  /// Throws a [path_provider.MissingPlatformDirectoryException] if the system is unable to
  /// provide the directory.
  static final applicationCacheDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('applicationCacheDirectory'),
  );

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  ///
  /// Consider using another path, such as [path_provider.getApplicationSupportDirectory],
  /// [path_provider.getApplicationCacheDirectory], or [path_provider.getExternalStorageDirectory], if the
  /// data is not user-generated.
  ///
  /// Example implementations:
  /// - `NSDocumentDirectory` on iOS and macOS.
  /// - The Flutter engine's `PathUtils.getDataDirectory` API on Android.
  ///
  /// Throws a [path_provider.MissingPlatformDirectoryException] if the system is unable to
  /// provide the directory.
  static final applicationDocumentsDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('applicationDocumentsDirectory'),
  );

  /// Path to a directory where the application may place application-specific
  /// cache files.
  ///
  /// If this directory does not exist, it is created automatically.
  ///
  /// Throws a [path_provider.MissingPlatformDirectoryException] if the system is unable to
  /// provide the directory.
  static final applicationSupportDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('applicationSupportDirectory'),
  );

  /// Path to the directory where downloaded files can be stored.
  ///
  /// The returned directory is not guaranteed to exist, so clients should verify
  /// that it does before using it, and potentially create it if necessary.
  ///
  /// Throws an [UnsupportedError] if this is not supported on the current
  /// platform.
  static final downloadsDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('downloadsDirectory'),
  );

  /// Path to a directory where the application may access top level storage.
  ///
  /// Example implementation:
  /// - `getExternalFilesDir(null)` on Android.
  ///
  /// Throws an [UnsupportedError] if this is not supported on the current
  /// platform (for example, on iOS where it is not possible to access outside
  /// the app's sandbox).
  static final externalStorageDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('externalStorageDirectory'),
  );

  /// Path to the directory where application can store files that are persistent,
  /// backed up, and not visible to the user, such as sqlite.db.
  ///
  /// Example implementations:
  /// - `NSApplicationSupportDirectory` on iOS and macOS.
  ///
  /// Throws an [UnsupportedError] if this is not supported on the current
  /// platform. For example, this is unlikely to ever be supported on Android,
  /// as no equivalent path exists.
  ///
  /// Throws a [path_provider.MissingPlatformDirectoryException] if the system is unable to
  /// provide the directory on a supported platform.
  static final libraryDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('libraryDirectory'),
  );

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  ///
  /// Files in this directory may be cleared at any time. This does *not* return
  /// a new temporary directory. Instead, the caller is responsible for creating
  /// (and cleaning up) files or directories within this directory. This
  /// directory is scoped to the calling application.
  ///
  /// Example implementations:
  /// - `NSCachesDirectory` on iOS and macOS.
  /// - `Context.getCacheDir` on Android.
  ///
  /// Throws a [path_provider.MissingPlatformDirectoryException] if the system is unable to
  /// provide the directory.
  static final temporaryDirectory = Provider<Directory>(
    (ref) => throw UnimplementedError('temporaryDirectory'),
  );

  /// 指定したディレクトリを上書きして返す.
  static List<Override> injectWithValue({
    Directory? applicationCacheDirectory,
    Directory? applicationDocumentsDirectory,
    Directory? applicationSupportDirectory,
    Directory? downloadsDirectory,
    Directory? externalStorageDirectory,
    Directory? libraryDirectory,
    Directory? temporaryDirectory,
  }) {
    return [
      if (applicationCacheDirectory != null)
        PathProviders.applicationCacheDirectory.overrideWithValue(
          applicationCacheDirectory,
        ),
      if (applicationDocumentsDirectory != null)
        PathProviders.applicationDocumentsDirectory.overrideWithValue(
          applicationDocumentsDirectory,
        ),
      if (applicationSupportDirectory != null)
        PathProviders.applicationSupportDirectory.overrideWithValue(
          applicationSupportDirectory,
        ),
      if (downloadsDirectory != null)
        PathProviders.downloadsDirectory.overrideWithValue(downloadsDirectory),
      if (externalStorageDirectory != null)
        PathProviders.externalStorageDirectory.overrideWithValue(
          externalStorageDirectory,
        ),
      if (libraryDirectory != null)
        PathProviders.libraryDirectory.overrideWithValue(libraryDirectory),
      if (temporaryDirectory != null)
        PathProviders.temporaryDirectory.overrideWithValue(temporaryDirectory),
    ];
  }

  /// 既定値での上書きを行う.
  static Future<List<Override>> inject() async {
    Future<T?> getOrNull<T>(Future<T> Function() f) async {
      try {
        return await f();
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {
        return null;
      }
    }

    final applicationCacheDirectory = await getOrNull(
      path_provider.getApplicationCacheDirectory,
    );
    final applicationDocumentsDirectory = await getOrNull(
      path_provider.getApplicationDocumentsDirectory,
    );
    final applicationSupportDirectory = await getOrNull(
      path_provider.getApplicationSupportDirectory,
    );
    final downloadsDirectory = await getOrNull(
      path_provider.getDownloadsDirectory,
    );
    final externalStorageDirectory = await getOrNull(
      path_provider.getExternalStorageDirectory,
    );
    final libraryDirectory = await getOrNull(path_provider.getLibraryDirectory);
    final temporaryDirectory = await getOrNull(
      path_provider.getTemporaryDirectory,
    );
    return injectWithValue(
      applicationCacheDirectory: applicationCacheDirectory,
      applicationDocumentsDirectory: applicationDocumentsDirectory,
      applicationSupportDirectory: applicationSupportDirectory,
      downloadsDirectory: downloadsDirectory,
      externalStorageDirectory: externalStorageDirectory,
      libraryDirectory: libraryDirectory,
      temporaryDirectory: temporaryDirectory,
    );
  }
}
