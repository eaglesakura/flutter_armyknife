# State Stream Riverpod

[state_stream](https://pub.dev/packages/state_stream) パッケージと [Riverpod](https://pub.dev/packages/flutter_riverpod) を連携させるための拡張ライブラリです。

## 特徴

- **Riverpod との完全統合** - StateStream を Riverpod Provider として使用可能
- **自動リソース管理** - Provider の自動破棄に対応
- **型安全な状態管理** - StateStream の型安全性を Riverpod で利用
- **リアクティブな UI 更新** - StateStream の状態変更を自動的に Widget に反映

## インストール

```yaml
dependencies:
  state_stream: ^1.0.0
  state_stream_riverpod: ^2.0.0
  flutter_riverpod: ^2.6.1
```

## 基本的な使い方

### StateStream を Riverpod Provider として使用

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// StateStream を提供する Provider を定義
final counterStreamProvider = Provider.autoDispose<MutableStateStream<int>>((ref) {
  final counter = MutableStateStream<int>(0);

  // Provider が破棄されるときに StateStream も破棄
  ref.onDispose(() {
    counter.close();
  });

  return counter;
});

// StateStream の状態を取得する Provider を定義
final counterProvider = StateStreamProviders.autoDispose.state<int>(
  counterStreamProvider,
);

// Widget で状態を使用
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('カウント: $count'),
        ElevatedButton(
          onPressed: () async {
            final counterStream = ref.read(counterStreamProvider);
            await counterStream.updateWithLock((state, emitter) async {
              await emitter.emit(state + 1);
              return null;
            });
          },
          child: Text('インクリメント'),
        ),
      ],
    );
  }
}
```

### 複雑な状態管理の例

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// 複雑な状態を管理する StateStream
class TodoState {
  final List<Todo> todos;
  final bool isLoading;

  const TodoState({
    required this.todos,
    required this.isLoading,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class Todo {
  final String id;
  final String title;
  final bool completed;

  const Todo({
    required this.id,
    required this.title,
    required this.completed,
  });
}

// TodoState を管理する Provider
final todoStreamProvider = Provider.autoDispose<MutableStateStream<TodoState>>((ref) {
  final todoStream = MutableStateStream<TodoState>(
    TodoState(todos: [], isLoading: false),
  );

  ref.onDispose(() {
    todoStream.close();
  });

  return todoStream;
});

// TodoState を取得する Provider
final todoProvider = StateStreamProviders.autoDispose.state<TodoState>(
  todoStreamProvider,
);

// TodoList を表示する Widget
class TodoListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoProvider);

    if (todoState.isLoading) {
      return CircularProgressIndicator();
    }

    return ListView.builder(
      itemCount: todoState.todos.length,
      itemBuilder: (context, index) {
        final todo = todoState.todos[index];
        return ListTile(
          title: Text(todo.title),
          trailing: Checkbox(
            value: todo.completed,
            onChanged: (value) async {
              final todoStream = ref.read(todoStreamProvider);
              await todoStream.updateWithLock((state, emitter) async {
                final updatedTodos = state.todos.map((t) {
                  if (t.id == todo.id) {
                    return Todo(
                      id: t.id,
                      title: t.title,
                      completed: value ?? false,
                    );
                  }
                  return t;
                }).toList();

                await emitter.emit(state.copyWith(todos: updatedTodos));
                return null;
              });
            },
          ),
        );
      },
    );
  }
}
```

### 非同期処理との組み合わせ

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// 非同期でデータを取得する StateStream
final userStreamProvider = Provider.autoDispose<MutableStateStream<User?>>((ref) {
  final userStream = MutableStateStream<User?>(null);

  // 初期化時にデータを取得
  _loadUser(userStream);

  ref.onDispose(() {
    userStream.close();
  });

  return userStream;
});

Future<void> _loadUser(MutableStateStream<User?> stream) async {
  await stream.updateWithLock((state, emitter) async {
    // ローディング状態の表現（別の状態クラスを使用）
    final user = await _fetchUserFromAPI();
    await emitter.emit(user);
    return null;
  });
}

final userProvider = StateStreamProviders.autoDispose.state<User?>(
  userStreamProvider,
);

class UserProfileWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return CircularProgressIndicator();
    }

    return Card(
      child: Column(
        children: [
          Text('名前: ${user.name}'),
          Text('メール: ${user.email}'),
        ],
      ),
    );
  }
}
```

## API リファレンス

### StateStreamProviders

Riverpod Provider として StateStream を使用するためのユーティリティクラスです。

#### StateStreamProviders.autoDispose

`Provider.autoDispose()` を使用した自動リソース管理を提供します。

```dart
AutoDisposeProvider<T> state<T>(
  AutoDisposeProvider<StateStream<T>> stateStreamProvider,
)
```

- `stateStreamProvider`: StateStream を提供する Provider
- 戻り値: StateStream の現在の状態を提供する Provider

## 基本的な状態管理について

このパッケージは Riverpod との連携機能のみを提供します。基本的な状態管理機能については、[state_stream](https://pub.dev/packages/state_stream) パッケージを参照してください。

## ライセンス

MIT License
