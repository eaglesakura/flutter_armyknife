import 'package:data_reference/data_reference.dart';

/// Flutter Bundle(Assets) からデータを読み込む.
abstract class FlutterBundleLoader {
  /// デフォルトのLoaderを取得する.
  factory FlutterBundleLoader() => const _FlutterBundleLoader();

  /// 指定データを読み込む.
  ///
  /// [path] はバンドル内のパス.
  /// [package] はパッケージ名.
  DataReference load({
    required String path,
    String? package,
  });
}

class _FlutterBundleLoader implements FlutterBundleLoader {
  const _FlutterBundleLoader();

  @override
  DataReference load({
    required String path,
    String? package,
  }) {
    return DataReference.flutterBundle(
      path,
      package: package,
    );
  }
}
