import 'package:collection/collection.dart';
import 'package:runtime_assert/runtime_assert.dart';

/// 内部にある例外を取り出すための関数.
///
/// NOTE.
/// dartはExceptionにJava/Kotlinの'cause'のような仕組みが無いため、
/// 内部にある例外を取り出すためには例外ごとに処理を記述する必要がある.
typedef ExceptionUnwrapper = Exception? Function(Exception e);

/// Golangのerrorsパッケージのような例外関連処理を提供する.
/// as https://pkg.go.dev/errors
final class Exceptions {
  static final _unwrapList = <ExceptionUnwrapper>[
    _unwrapImpl,
  ];

  const Exceptions._();

  /// [unwrap] に追加する.
  static int addUnwrapper(ExceptionUnwrapper unwrap) {
    _unwrapList.add(unwrap);
    return _unwrapList.length;
  }

  /// 指定の型の例外を取り出す.
  static T? find<T extends Exception>(Exception? e) {
    return unwrap(e).whereType<T>().firstOrNull;
  }

  /// [e] に含まれるすべての例外を列挙する.
  /// e!=nullである場合、 [e] 自身も列挙される.
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

  static Exception? _unwrapImpl(Exception e) {
    return switch (e) {
      IllegalArgumentException _ => e.cause,
      IllegalStateException _ => e.cause,
      UnsupportedPlatformException _ => e.cause,
      _ => null
    };
  }
}
