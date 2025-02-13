import 'dart:io' as io;

/// [Future.delayed(duration)]の糖衣構文.
Future delayed(Duration duration) => Future.delayed(duration);

/// Dartの実行ループ1イテレーションをスキップする.
/// 明示的に他の処理を行いたい場合に利用する.
Future nop() => Future.microtask(() async {});

/// 指定の型が一致するかどうかを判定する.
/// Generics等で型の一致を確認する際に利用する.
bool typeEquals<T, T2>() => T == T2;

/// アクセスのみを行い、値を返す.
T touch<T>(T t) => t;

/// Webプラットフォームであればtrue.
///
/// NOTE.
/// Webプラットフォームでは [io.Platform.isAndroid] 等が例外を投げるため、
/// それを利用して判定を行う.
final bool kIsWebCompat = () {
  try {
    return io.Platform.isAndroid != io.Platform.isAndroid;
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    return true;
  }
}();
