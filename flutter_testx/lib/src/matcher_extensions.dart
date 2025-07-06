import 'package:flutter_test/flutter_test.dart';

/// 型検証を行い、その型を返す
T expectIsA<T>(
  dynamic value, {
  String? reason,
  dynamic skip,
}) {
  expect(value, isA<T>(), reason: reason, skip: skip);
  return value as T;
}

/// インスタンスがTであることを確認し、assertionを実行する.
R expectInstanceOf<T, R>(
  dynamic actual,
  TypeMatcher<T> matcher,
  R Function(T value) assertion,
) {
  expect(actual, matcher);
  return assertion(actual as T);
}
