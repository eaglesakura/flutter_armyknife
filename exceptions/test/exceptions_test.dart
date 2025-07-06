import 'package:armyknife_exceptions/armyknife_exceptions.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    Exceptions.addUnwrapper((e) {
      if (e is TestException2) {
        return e.cause;
      }
      return null;
    });
  });
  test('ルートレベルを取得できる', () {
    final e = TestException('test');
    final unwrapped = Exceptions.unwrap(e);
    expect(unwrapped, [e]);
    expect(Exceptions.find<TestException>(e), equals(e));
  });

  test('ネストした例外を取得できる', () {
    final e = TestException2('test', TestException('test2'));
    final unwrapped = Exceptions.unwrap(e);
    expect(unwrapped, [e, e.cause!]);
    expect(Exceptions.find<TestException>(e), isNotNull);
  });
}

class TestException implements Exception {
  final String message;

  TestException(this.message);
}

class TestException2 implements Exception {
  final String message;

  final Exception? cause;

  TestException2(this.message, this.cause);
}
