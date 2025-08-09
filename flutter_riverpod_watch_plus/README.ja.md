Riverpod の `Ref.watch()` がIterableやMapのdeep-equalsに対応していない問題を解決するライブラリである。
コレクション（List、Map、Set）を監視する際の参照比較による不要な再描画を防ぎ、効率的な状態管理を実現する。

## Features

- **Deep Equals対応**: List、Map、Setのディープ比較による効率的な状態監視
- **不要な再描画防止**: コレクションの内容が同じ場合の再描画を回避
- **拡張関数提供**: `Ref.watchBy()` および `WidgetRef.watchBy()` による簡単な利用

## Getting started

`pubspec.yaml`に以下の依存関係を追加する：

```yaml
dependencies:
  flutter_riverpod_watch_plus: ^1.0.0
```

## Usage

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_watch_plus/flutter_riverpod_watch_plus.dart';

// 通常のListを監視するProvider
final listProvider = StateProvider<List<String>>((ref) => ['a', 'b', 'c']);

// 従来の監視方法（参照比較のため不要な再描画が発生）
final badExample = Provider((ref) {
  final list = ref.watch(listProvider); // 内容が同じでも再描画される
  return list.length;
});

// watchBy()を使用した監視（Deep Equalsで効率的）
final goodExample = Provider((ref) {
  final list = ref.watchBy(listProvider, (value) => value); // 内容が同じなら再描画されない
  return list.length;
});

// Widget内での使用例
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRefでもwatchBy()が使用できる
    final filteredList = ref.watchBy(
      listProvider,
      (list) => list.where((item) => item.startsWith('a')).toList(),
    );

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(filteredList[index]));
      },
    );
  }
}
```

## Additional information

このパッケージは Riverpod の `Ref.watch()` 機能を拡張し、コレクションのdeep-equalsサポートを提供する。
中間オブジェクト（WatchValue）を使用してコレクションの内容比較を行い、不要な再描画を防ぐ。
バグ報告や機能要求は[GitHub](https://github.com/eaglesakura/flutter_armyknife)で受け付けている。
