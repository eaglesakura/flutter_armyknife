Flutter Test を便利に使用するための小さな Utility 集である。型検証を簡潔に記述するためのヘルパー関数を提供する。

## Features

- **型検証とキャスト**: `expectIsA<T>()` により、型検証と安全なキャストを同時に実行
- **型安全なアサーション**: `expectInstanceOf<T, R>()` により、型検証後に型安全なアサーションを実行

## Getting started

`pubspec.yaml` に以下の依存関係を追加する：

```yaml
dev_dependencies:
  armyknife_flutter_testx: ^1.0.0
```

## Usage

### 基本的な型検証とキャスト

```dart
import 'package:armyknife_flutter_testx/armyknife_flutter_testx.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('型検証とキャストの例', () {
    dynamic value = 'Hello World';

    // 型検証を行い、キャストされた値を取得
    String result = expectIsA<String>(value);
    expect(result.length, 11);
  });

  test('型安全なアサーションの例', () {
    dynamic value = [1, 2, 3];

    // 型検証後にアサーションを実行
    int length = expectInstanceOf<List<int>, int>(
      value,
      isA<List<int>>(),
      (list) => list.length,
    );
    expect(length, 3);
  });
}
```

## Additional information

このライブラリは Flutter Test の型検証を簡潔に記述するためのヘルパー関数を提供する。特に複雑な型検証とキャストを頻繁に行うテストコードにおいて、コードの可読性と保守性を向上させる。

問題やフィードバックがある場合は、GitHub リポジトリで Issue を作成してください。
