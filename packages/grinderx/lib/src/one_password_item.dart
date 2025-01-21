import 'package:grinder/grinder.dart';

/// One Passwordに保存されてている１アイテム用のアクセサオブジェクト.
/// アクセスの実態は `op` コマンドである.
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
    final result = await runAsync('op', arguments: [
      'read',
      'op://$vault/$item/$field',
    ]);
    if (trimResult) {
      return result.trim();
    } else {
      return result;
    }
  }
}
