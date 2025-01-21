import 'package:meta/meta.dart';

/// ローカライズテキストのリクエストデータ.
@internal
class LocalizeStringSource {
  final String id;
  final List<String> arguments;

  LocalizeStringSource(this.id, this.arguments);
}
