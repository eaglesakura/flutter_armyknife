import 'package:dartxx/dartxx.dart';
import 'package:test/test.dart';

void main() {
  test('Iterable.distinctUnique', () {
    final result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].distinctUnique();
    expect(result, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

    final result2 = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10
    ].distinctUnique();
    expect(result2, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });
}
