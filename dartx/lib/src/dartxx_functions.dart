import 'dart:io' as io;

/// [Future.delayed]の糖衣構文.
///
/// [duration]だけ処理を中断してから完了する.
///
/// Example:
/// ```dart
/// await delayed(const Duration(milliseconds: 50));
/// ```
Future delayed(Duration duration) => Future.delayed(duration);

/// Dartの実行ループ1イテレーションをスキップする.
///
/// 明示的に他の処理を行いたい場合に利用する.
///
/// Example:
/// ```dart
/// await nop();
/// ```
Future nop() => Future.microtask(() async {});

/// 指定の型が一致するかどうかを判定する.
///
/// Generics等で型の一致を確認する際に利用する.
///
/// Example:
/// ```dart
/// final same = typeEquals<int, int>();
/// final different = typeEquals<int, String>();
/// ```
bool typeEquals<T, T2>() => T == T2;

/// アクセスのみを行い、値を返す.
///
/// [t] をそのまま返し、副作用を伴う式の評価を明示したい場面で使う.
///
/// Example:
/// ```dart
/// final value = touch(42);
/// ```
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
