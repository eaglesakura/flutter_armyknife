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

  test('Map.merge', () {
    final result = MapX.merge<String, dynamic>(
      {
        'a': 1,
        'b': 2,
        'd': {
          'e': 5,
          'f': 6,
        },
      },
      {
        'b': 3,
        'c': 4,
        'd': {
          'g': 7,
        }
      },
    );
    expect(result, {
      'a': 1,
      'b': 3,
      'c': 4,
      'd': {
        'e': 5,
        'f': 6,
        'g': 7,
      },
    });
  });
}
