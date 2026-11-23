import 'package:collection/collection.dart';

/// 内部にある例外を取り出すための関数.
///
/// NOTE.
/// dartはExceptionにJava/Kotlinの'cause'のような仕組みが無いため、
/// 内部にある例外を取り出すためには例外ごとに処理を記述する必要がある.
typedef ExceptionUnwrapper = Exception? Function(Exception e);

/// Golangのerrorsパッケージのような例外関連処理を提供する.
/// as https://pkg.go.dev/errors
final class Exceptions {
  /// 登録済みの [ExceptionUnwrapper] 一覧.
  static final _unwrapList = <ExceptionUnwrapper>[];

  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// // Exceptions は静的メソッドのみ利用する
  /// ```
  const Exceptions._();

  /// [unwrap]に追加する.
  ///
  /// [unwrap]は内側の例外を返す関数として登録される.
  /// 登録後のリスト長を返す.
  ///
  /// Example:
  /// ```dart
  /// Exceptions.addUnwrapper((e) {
  ///   if (e is FormatException) {
  ///     return null;
  ///   }
  ///   return null;
  /// });
  /// ```
  static int addUnwrapper(ExceptionUnwrapper unwrap) {
    _unwrapList.add(unwrap);
    return _unwrapList.length;
  }

  /// 指定の型の例外を取り出す.
  ///
  /// [e]から[unwrap]で辿れる例外列のうち、最初の[T]を返す.
  /// 見つからない場合は`null`.
  ///
  /// Example:
  /// ```dart
  /// final found = Exceptions.find<FormatException>(
  ///   const FormatException('bad'),
  /// );
  /// ```
  static T? find<T extends Exception>(Exception? e) {
    return unwrap(e).whereType<T>().firstOrNull;
  }

  /// [e]に含まれるすべての例外を列挙する.
  ///
  /// e!=nullである場合、[e]自身も列挙される.
  /// 登録された[ExceptionUnwrapper]で内側へ辿り、変化がなくなったら終了する.
  ///
  /// Example:
  /// ```dart
  /// for (final ex in Exceptions.unwrap(const FormatException('bad'))) {
  ///   print(ex);
  /// }
  /// ```
  static Iterable<Exception> unwrap(Exception? e) sync* {
    var current = e;

    while (current != null) {
      yield current;

      // 最初にunwrapできる関数を探す
      current = _unwrapList.map((func) {
        final result = func(current!);
        if (result == current) {
          // 変化がなければ行き止まり
          return null;
        } else {
          return result;
        }
      }).firstOrNull;
    }
  }
}
