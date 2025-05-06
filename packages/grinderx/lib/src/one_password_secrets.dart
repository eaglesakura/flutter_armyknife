import 'package:grinderx/src/one_password_item.dart';
import 'package:loggerx/loggerx.dart';

final _log = Logger.of(OnePasswordSecrets);

/// 1Passwordのシークレット情報を読み込む.
class OnePasswordSecrets {
  final OnePasswordItem op;

  OnePasswordSecrets(this.op);

  /// 指定されたフィールドを読み込む.
  Future<Map<String, String>> readFields(List<String> fields) async {
    final result = <String, String>{};
    for (final field in fields) {
      final key = field.split('/').last;
      _log.i('read $key <- $field');
      final value = await op.read(field: field);
      result[key] = value;
    }
    return result;
  }
}
