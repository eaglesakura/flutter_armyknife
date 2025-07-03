import 'dart:io';

import 'package:grinder/grinder.dart';

/// One Passwordに保存されてている１アイテム用のアクセサオブジェクト.
/// アクセスの実態は `op` コマンドである.
///
/// `op signin` コマンドを使用し、事前に1passwordの任意アカウントにログインしておく必要がある.
class OnePasswordItem {
  final String vault;
  final String item;

  const OnePasswordItem({
    required this.vault,
    required this.item,
  });

  /// 指定した1passwordアイテムを読み込む.
  /// 内部実装は `op` コマンドを使用するため、事前にインストールとログインが必要.
  Future<String> read({
    required String field,
    bool trimResult = true,
  }) async {
    final result = await runAsync(
      'op',
      arguments: [
        'read',
        'op://$vault/$item/$field',
      ],
    );
    if (trimResult) {
      return result.trim();
    } else {
      return result;
    }
  }

  /// 指定した1passwordアイテムをファイルに保存する.
  /// 内部実装は `op` コマンドを使用するため、事前にインストールとログインが必要.
  ///
  /// [force] がtrueの場合、ファイルが存在する場合は上書きされる.
  /// デフォルトはtrueである.
  Future<String> readFile({
    required File output,
    bool force = true,
    required String field,
  }) async {
    final result = await runAsync(
      'op',
      arguments: [
        'read',
        if (force) '--force',
        '--out-file',
        output.path,
        'op://$vault/$item/$field',
      ],
    );
    return result;
  }
}
