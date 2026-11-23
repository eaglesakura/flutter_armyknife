import 'package:flutter_test/flutter_test.dart';

/// 型検証を行い、その型を返す.
///
/// [value]が[T]であることを[expect]で検証し、成功時に[T]として返す.
/// [reason] / [skip]は[expect]へそのまま渡す.
///
/// Example:
/// ```dart
/// final text = expectIsA<String>('hello', reason: '文字列であること');
/// ```
T expectIsA<T>(
  dynamic value, {
  String? reason,
  dynamic skip,
}) {
  expect(value, isA<T>(), reason: reason, skip: skip);
  return value as T;
}

/// インスタンスがTであることを確認し、assertionを実行する.
///
/// [actual]が[matcher]に一致することを検証したうえで、
/// [assertion]に型付き値を渡して結果[R]を返す.
///
/// Example:
/// ```dart
/// final length = expectInstanceOf<String, int>(
///   'abc',
///   isA<String>(),
///   (value) => value.length,
/// );
/// ```
R expectInstanceOf<T, R>(
  dynamic actual,
  TypeMatcher<T> matcher,
  R Function(T value) assertion,
) {
  expect(actual, matcher);
  return assertion(actual as T);
}
