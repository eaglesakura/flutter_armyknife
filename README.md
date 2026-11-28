# Flutter Armyknife 🔧

![Flutter Armyknife](./docs/res/armyknife_logo.png)

**Flutter Armyknife** is a collection of utility libraries for Dart and Flutter developers that provides small conveniences, just like a "Swiss Army knife."

To solve various challenges encountered in daily development work, it provides numerous lightweight and easy-to-use small libraries. Each library can be used independently, and you can select only the ones you need according to your project requirements.

## 🌟 Features

- **Lightweight Design**: Each library is specialized for minimal necessary functionality
- **Type Safety**: Safe code utilizing Dart's type system
- **Independence**: Each library can be used independently
- **Practicality**: Designed based on challenges encountered in actual development environments

## 📚 Library List

| Category | Library | Overview | Main Features |
| ---------- | --------- | ---------- | --------------- |
| 🔄 Async Processing・Concurrency | **[async_notify2](./async_notify2/)** | Reproduces Java/Kotlin notify/wait | Async processing synchronization, type-safe value transmission |
| 🔄 Async Processing・Concurrency | **[future_context2](./future_context2/)** | Cancellable async processing | Async processing cancellation, timeout, hierarchical management |
| 🔄 Async Processing・Concurrency | **[future_context2_hooks](./future_context2_hooks/)** | FutureContext Hooks integration | FutureContext Flutter Hooks integration, Widget lifecycle coordination |
| 🔄 Async Processing・Concurrency | **[task_queue](./task_queue/)** | Ordered task execution system | Task order guarantee, synchronous execution control |
| 🏗️ Data Processing・Transformation | **[dartx](./dartx/)** | Dart basic functionality extension | Iterable extensions, type checking, collection building |
| 🏗️ Data Processing・Transformation | **[streams](./streams/)** | RxDart-based Stream operations | Stream merging, generative Streams, Future-Stream conversion |
| 🏗️ Data Processing・Transformation | **[yamlx](./yamlx/)** | YAML file processing | YAML Map conversion, merge functionality, path-based retrieval |
| 🗄️ Database・Persistence | **[driftx](./driftx/)** | Drift database extensions | SQLite result codes, multi-database concurrent transactions |
| 🎯 State Management | **[flutter_riverpod_watch_plus](./flutter_riverpod_watch_plus/)** | Riverpod watch() extension library | Collection deep equals support, prevent unnecessary re-renders |
| 🎯 State Management | **[riverpodx](./riverpodx/)** | Riverpod support library | ProviderContainer building, Stream hooks, list-type properties |
| 🎯 State Management | **[riverpod_container_async](./riverpod_container_async/)** | ProviderContainer async support | Async initialization/disposal, task queue management |
| 🎯 State Management | **[state_stream](./state_stream/)** | Lightweight state management | Type-safe state management, reactive updates, thread-safe |
| 🎯 State Management | **[state_stream_riverpod](./state_stream_riverpod/)** | state_stream Riverpod integration | Integration with Riverpod providers |
| 🧪 Test Support | **[flutter_testx](./flutter_testx/)** | Flutter Test extensions | Type validation and casting, type-safe assertions |
| 🧪 Test Support | **[test_context](./test_context/)** | Test context | Per-test instance guarantee, automatic cleanup |
| 🧪 Test Support | **[riverpod_container_async_test](./riverpod_container_async_test/)** | riverpod_container_async test support | Testing features for riverpod_container_async |
| 🔧 Flutter Extensions | **[flutterx](./flutterx/)** | Flutter SDK extensions | Test environment detection, frame sync waiting |
| 📝 Logging・Debug | **[logger](./logger/)** | Unified logging library interface | 4 log levels, platform-independent |
| 📝 Logging・Debug | **[logger_flutter](./logger_flutter/)** | Flutter logging implementation | Log output for Flutter applications |
| 📝 Logging・Debug | **[logger_grinder](./logger_grinder/)** | Grinder logging implementation | Log output for build tools |
| ⚡ Error Handling | **[exceptions](./exceptions/)** | Exception trace functionality | Exception unwrapping, exception chain search, custom unwrappers |
| ⏰ Time Processing | **[time](./time/)** | Lightweight time processing | time_machine wrapper, Clock delegate, Unix epoch |
| 🛤️ Route Lifecycle | **[route_lifecycle_detector](./route_lifecycle_detector/)** | Navigator lifecycle management | Dialog multiple display prevention, Route state detection, async processing control |
| 🛠️ Code Generation | **[openapi-template](./openapi-template/)** | OpenAPI code generation template | Dart/Flutter OpenAPI client generation, custom templates |

## 🛠 Development Environment (mise)

Flutter is managed with **mise** via `.mise.toml`.

```bash
# Install mise first: https://mise.jdx.dev/
mise install
mise exec -- flutter --version   # expect Flutter 3.50.0.x
mise exec -- dart pub get
mise exec -- flutter test
```

## Installing APM SKILLs

This repository root is an [APM (Agent Package Manager)](https://microsoft.github.io/apm/) package (`apm.yml` / `.apm/skills/`).
It ships agent-facing SKILLs that document how to use the [flutter_armyknife](https://github.com/eaglesakura/flutter_armyknife) packages in a consuming project.

APM CLI is required. If it is not installed yet, see [Installation](https://microsoft.github.io/apm/getting-started/installation/).

```bash
apm --version
```

From the consuming repository root, initialize once if needed:

```bash
apm init
```

Then add this package with either approach below. Pin a tag in production (recommended): `eaglesakura/flutter_armyknife#v0.1.0`.

### Declare in `apm.yml`, then install

Edit the consuming project's `apm.yml` and list the package under `dependencies.apm`:

```yaml
name: my-app
version: 0.1.0
dependencies:
  apm:
    - eaglesakura/flutter_armyknife#v0.1.0
    # Local path (development):
    # - ./path/to/flutter_armyknife
```

Install (or restore after `git clone`):

```bash
apm install
```

### Install with a direct package argument

Pass the package to `apm install`. APM resolves it and updates `apm.yml` / `apm.lock.yaml`:

```bash
# GitHub shorthand
apm install eaglesakura/flutter_armyknife

# Pin a tag (recommended)
apm install eaglesakura/flutter_armyknife#v0.1.0

# Local path (development)
apm install ./path/to/flutter_armyknife
```

### What to commit

Commit `apm.yml`, `apm.lock.yaml`, and `.gitignore` (plus any authored `.apm/`). Do not commit `apm_modules/`. Teammates restore dependencies with `apm install` after `git clone`.

### Shipped SKILLs

Located under `.apm/skills/`. Each SKILL covers when to use it, main usage, combinations, and cleanup.

| SKILL | Target (directory / pub name) |
| --- | --- |
| `pub-flutter-async-notify2` | async_notify2 |
| `pub-flutter-flutter-riverpod-watch-plus` | flutter_riverpod_watch_plus |
| `pub-flutter-future-context2` | future_context2 |
| `pub-flutter-future-context2-hooks` | future_context2_hooks |
| `pub-flutter-logger` | logger / **armyknife_logger** |
| `pub-flutter-logger-flutter` | logger_flutter / **armyknife_logger_flutter** |
| `pub-flutter-logger-grinder` | logger_grinder / **armyknife_logger_grinder** |
| `pub-flutter-riverpod-container-async` | riverpod_container_async |
| `pub-flutter-riverpod-container-async-test` | riverpod_container_async_test |
| `pub-flutter-riverpod-container-builder` | riverpod_container_builder |
| `pub-flutter-route-lifecycle-detector` | route_lifecycle_detector |
| `pub-flutter-state-stream` | state_stream |
| `pub-flutter-state-stream-riverpod` | state_stream_riverpod |
| `pub-flutter-task-queue` | task_queue / **armyknife_task_queue** |
| `pub-flutter-test-context` | test_context / **armyknife_test_context** |
| `pub-flutter-time` | time / **armyknife_time** |

Examples are generalized from Example code. When README and implementation disagree, the SKILL treats the implementation as authoritative.

## 🚀 Getting Started

Each library can be used independently. Add the necessary libraries to your `pubspec.yaml`:

```yaml
dependencies:
  armyknife_dartx: ^1.0.0
  armyknife_future_context2: ^1.0.1
  armyknife_riverpodx: ^1.0.0
  flutter_riverpod_watch_plus: ^1.0.0
  # Other necessary libraries
```

## 📖 Documentation

For detailed usage of each library, please refer to the README.md in each directory.

## 🤝 Contributing

This project is managed at [flutter_armyknife](https://github.com/eaglesakura/flutter_armyknife).

- **Bug Reports**: [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues)
- **Feature Requests**: [GitHub Issues](https://github.com/eaglesakura/flutter_armyknife/issues)
- **Pull Requests**: Welcome

## 📄 License

MIT License

---

> 🔧 **Armyknife** - Small conveniences, always within reach.
