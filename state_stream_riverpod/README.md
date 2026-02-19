# State Stream Riverpod

An extension library for integrating the [state_stream](https://pub.dev/packages/state_stream) package with [Riverpod](https://pub.dev/packages/flutter_riverpod).

## Features

- **Complete Riverpod Integration** - Use StateStream as Riverpod Provider
- **Automatic Resource Management** - Support for automatic Provider disposal
- **Type-safe State Management** - Utilize StateStream's type safety with Riverpod
- **Reactive UI Updates** - Automatically reflect StateStream state changes to Widgets

## Installation

```yaml
dependencies:
  state_stream: ^1.0.0
  state_stream_riverpod: ^2.0.1
  flutter_riverpod: ^3.0.0
```

## Basic Usage

### Using StateStream as Riverpod Provider

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// Define Provider that provides StateStream
final counterStreamProvider = Provider.autoDispose<MutableStateStream<int>>((ref) {
  final counter = MutableStateStream<int>(0);

  // Dispose StateStream when Provider is disposed
  ref.onDispose(() {
    counter.close();
  });

  return counter;
});

// Define Provider that gets StateStream state
final counterProvider = StateStreamProviders.autoDispose.state<int>(
  counterStreamProvider,
);

// Use state in Widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () async {
            final counterStream = ref.read(counterStreamProvider);
            await counterStream.updateWithLock((state, emitter) async {
              await emitter.emit(state + 1);
              return null;
            });
          },
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### Complex State Management Example

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// StateStream managing complex state
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

// Provider managing TodoState
final todoStreamProvider = Provider.autoDispose<MutableStateStream<TodoState>>((ref) {
  final todoStream = MutableStateStream<TodoState>(
    TodoState(todos: [], isLoading: false),
  );

  ref.onDispose(() {
    todoStream.close();
  });

  return todoStream;
});

// Provider for getting TodoState
final todoProvider = StateStreamProviders.autoDispose.state<TodoState>(
  todoStreamProvider,
);

// Widget displaying TodoList
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

### Combination with Asynchronous Processing

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_stream/state_stream.dart';
import 'package:state_stream_riverpod/state_stream_riverpod.dart';

// StateStream that fetches data asynchronously
final userStreamProvider = Provider.autoDispose<MutableStateStream<User?>>((ref) {
  final userStream = MutableStateStream<User?>(null);

  // Fetch data on initialization
  _loadUser(userStream);

  ref.onDispose(() {
    userStream.close();
  });

  return userStream;
});

Future<void> _loadUser(MutableStateStream<User?> stream) async {
  await stream.updateWithLock((state, emitter) async {
    // Loading state representation (using separate state class)
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
          Text('Name: ${user.name}'),
          Text('Email: ${user.email}'),
        ],
      ),
    );
  }
}
```

## API Reference

### StateStreamProviders

Utility class for using StateStream as Riverpod Provider.

#### StateStreamProviders.autoDispose

Provides automatic resource management using `Provider.autoDispose()`.

```dart
AutoDisposeProvider<T> state<T>(
  AutoDisposeProvider<StateStream<T>> stateStreamProvider,
)
```

- `stateStreamProvider`: Provider that provides StateStream
- Return value: Provider that provides the current state of StateStream

## About Basic State Management

This package only provides Riverpod integration functionality. For basic state management features, please refer to the [state_stream](https://pub.dev/packages/state_stream) package.

## License

MIT License
