Golang の`errors`パッケージのような例外トレース Util を提供する Dart ライブラリです。例外の内部にある例外を取り出したり、例外チェーンをトレースすることができます。

## Features

- **例外のアンラップ**: 例外の内部にある例外を取り出すことができる
- **例外の検索**: 指定の型の例外を例外チェーンから検索できる
- **例外チェーンの列挙**: 例外に含まれるすべての例外を列挙できる
- **カスタムアンラッパー**: 独自の例外アンラップ処理を追加できる

## Getting started

`pubspec.yaml`に依存関係を追加してください：

```yaml
dependencies:
  armyknife_exceptions: ^1.0.0
```

その後、`pub get`を実行してパッケージをインストールしてください。

## Usage

### 基本的な使用例

```dart
import 'package:armyknife_exceptions/armyknife_exceptions.dart';

void main() {
  try {
    // 何らかの処理
    throwNestedException();
  } catch (e) {
    if (e is Exception) {
      // 例外チェーンをすべて列挙
      for (final exception in Exceptions.unwrap(e)) {
        print('Exception: $exception');
      }

      // 特定の型の例外を検索
      final specificException = Exceptions.find<ArgumentError>(e);
      if (specificException != null) {
        print('Found ArgumentError: $specificException');
      }
    }
  }
}
```

### カスタムアンラッパーの追加

```dart
// カスタム例外アンラップ処理を追加
Exceptions.addUnwrapper((exception) {
  if (exception is YourCustomException) {
    return exception.innerException;
  }
  return null;
});
```

## Additional information

このパッケージは、Dart の例外処理をより柔軟にするために開発されました。Golang の`errors`パッケージからインスピレーションを得ており、例外チェーンの処理を簡単にします。

パッケージに関する質問や問題があれば、GitHub の Issue で報告してください。
