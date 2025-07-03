import 'dart:io';

import 'package:grinderx/grinderx.dart';
import 'package:test/test.dart';

void main() {
  test('プロパティを読み込める', () async {
    final props = ProjectProperties.load(
      files: [
        File('test_asset/prop_0.properties').absolute,
        File('test_asset/prop_1.properties').absolute,
      ],
    );

    expect(props.get('valueA'), 'abc');
    expect(props.get('valueB'), 'def');
    expect(props.get('valueC'), 'ccc');
    expect(props.get('valueD'), 'ghi');
    expect(props.get('valueE', requireValue: false), '');
    expect(props.containsKey('noKey'), isFalse);
    expect(props.getOrdered(['valueE', 'valueD']), 'ghi');
  });
}
