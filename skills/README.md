# flutter-armyknife skills

[flutter_armyknife](https://github.com/eaglesakura/flutter_armyknife) ライブラリ群の利用方法をまとめた APM SKILL パッケージである。

## Quick Start

```yaml
dependencies:
  apm:
    - eaglesakura/flutter_armyknife/skills#main
```

## SKILLS

※ `.apm/skills/` 配下。各 SKILL は「いつ使うか / 主な使い方 / 組み合わせ / 解放」を示す。

| SKILL | 対象（ディレクトリ / pub 名） |
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
| `pub-flutter-route-lifecycle-detector` | route_lifecycle_detector |
| `pub-flutter-state-stream` | state_stream |
| `pub-flutter-state-stream-riverpod` | state_stream_riverpod |
| `pub-flutter-task-queue` | task_queue / **armyknife_task_queue** |
| `pub-flutter-test-context` | test_context / **armyknife_test_context** |
| `pub-flutter-time` | time / **armyknife_time** |

例示は Example コードに一般化している。README と実装が食い違う点は SKILL 側で実装を正とする。
