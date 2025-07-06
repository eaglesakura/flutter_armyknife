import 'dart:async';

import 'package:async_notify2/async_notify2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:future_context2/future_context2.dart';

void main() {
  late FutureContext context;
  late Stream<bool> canceledStream;
  setUp(() async {
    debugPrint('setUp');
    context = FutureContext();
    canceledStream = context.isCanceledStream;

    unawaited(() async {
      try {
        await for (final cancel in context.isCanceledStream) {
          debugPrint('isCanceled: $cancel');
        }
      } finally {
        debugPrint('isCanceledStream done');
      }
    }());
  });
  tearDown(() async {
    debugPrint('context close');
    await context.close();
    await canceledStream.last; // キャンセルストリームが終了してgc対象となる
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // キャンセル済みなので、これは常にtrueである
    expect(
      await context.isCanceledStream.where((event) => event).first,
      isTrue,
    );
    debugPrint('tearDown');
  });

  group('FutureContext.suspend', () {
    test('suspend', () async {
      debugPrint('suspend start');
      final value = await context.suspend((context) async {
        await Future<void>.delayed(const Duration(seconds: 1));
        debugPrint('suspend return');
        return 100;
      });
      debugPrint('suspend done');
      expect(value, 100);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('delayed', () async {
      final sw = Stopwatch();
      sw.start();
      debugPrint('start delayed');
      await context.delayed(const Duration(milliseconds: 110));
      sw.stop();
      debugPrint('elapsedMilliseconds: ${sw.elapsedMilliseconds} ms');
      debugPrint('closed stream');
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(110));
      expect(sw.elapsedMilliseconds, lessThan(120));
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('delayed(seconds)', () async {
      final sw = Stopwatch();
      sw.start();
      debugPrint('start delayed');
      await context.delayed(const Duration(seconds: 1));
      sw.stop();
      debugPrint('elapsedMilliseconds: ${sw.elapsedMilliseconds} ms');
      debugPrint('closed stream');
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(1000));
      expect(sw.elapsedMilliseconds, lessThan(1100));
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('delayed(cancel)', () async {
      unawaited(() async {
        await Future<void>.delayed(const Duration(seconds: 1));
        await context.close();
      }());
      try {
        debugPrint('start delayed');
        await context.delayed(const Duration(seconds: 10));
        fail('always Nothing');
      } on CancellationException catch (e, stackTrace) {
        debugPrint('throws CancellationException');
        debugPrint('$e, $stackTrace');
      }
    });

    test('error', () async {
      try {
        await context.suspend((context) async {
          await Future.delayed(const Duration(milliseconds: 100));
          throw Exception('error');
        });
        // ignore: dead_code
        fail('always Nothing');
        // ignore: avoid_catches_without_on_clauses
      } catch (e, stackTrace) {
        debugPrint('$e, $stackTrace');
      }
    });

    test('cancel', () async {
      unawaited(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await context.close();
      }());
      try {
        final value = await context.suspend((context) async {
          try {
            await context.delayed(const Duration(seconds: 10));
            return 100;
          } finally {
            debugPrint('finish suspend');
          }
        });
        fail('always Nothing: $value');
      } on CancellationException catch (e, stackTrace) {
        debugPrint('throws CancellationException');
        debugPrint('$e, $stackTrace');
        // OK!
      }
    });

    test('group', () async {
      final ctx2 = FutureContext();
      final groupContext = FutureContext.group({context, ctx2});

      expect(ctx2.isActive, isTrue);
      expect(groupContext.isActive, isTrue);
      expect(ctx2.isCanceled, isFalse);
      expect(groupContext.isCanceled, isFalse);

      // 親をキャンセル
      await ctx2.close();

      expect(ctx2.isActive, isFalse);
      expect(groupContext.isActive, isFalse);
      expect(ctx2.isCanceled, isTrue);
      expect(groupContext.isCanceled, isTrue);
    });
    test('group.cancel', () async {
      final ctx2 = FutureContext(tag: 'second');
      final groupContext = FutureContext.group(
        {context, ctx2},
        tag: 'group',
      );

      unawaited(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await groupContext.close();
      }());

      try {
        await groupContext.delayed(const Duration(seconds: 10));
        fail('always Nothing');
      } on CancellationException catch (e, stackTrace) {
        debugPrint('throws CancellationException');
        debugPrint('$e, $stackTrace');
      }
    });
  });

  group('FutureContext.timeout', () {
    test('timeout(success)', () async {
      final result = await context.withTimeout<int>(
        const Duration(seconds: 10),
        (context) async {
          await context.delayed(const Duration(seconds: 1));
          return 1;
        },
      );
      expect(result, 1);
    });

    test('timeout', () async {
      try {
        await context.withTimeout<void>(
          const Duration(seconds: 1),
          (context) async {
            await context.delayed(const Duration(seconds: 10));
          },
        );
        fail('not calling');
      } on TimeoutException catch (e, stackTrace) {
        debugPrint('OK, $e, $stackTrace');
      }
    });
    test('timeout(Blocking)', () async {
      try {
        await context.withTimeout<void>(
          const Duration(seconds: 1),
          (context) async {
            await Future<void>.delayed(const Duration(seconds: 10));
          },
        );
        fail('not calling');
      } on TimeoutException catch (e, stackTrace) {
        debugPrint('OK, $e, $stackTrace');
      }
    });
  });

  // group('Stream', () {
  //   test('done', () async {
  //     final stream = Stream.periodic(
  //       const Duration(milliseconds: 100),
  //       (i) => i,
  //     ).takeWhile((element) => element < 10).withContext(context);
  //     var received = 0;
  //     await for (final v in stream) {
  //       ++received;
  //       debugPrint('stream: $v');
  //     }
  //     expect(received, 10);
  //   });

  //   // test('isCanceledStream', () async {
  //   //   final context = FutureContext(tag: 'testing');
  //   //   // final stream = context.isCanceledStream
  //   //   //     .distinct()
  //   //   //     .timeout(const Duration(seconds: 1), onTimeout: (controller) {
  //   //   //   debugPrint('onTimeout');
  //   //   //   return controller.close();
  //   //   // });
  //   //   unawaited(() async {
  //   //     await Future<void>.delayed(const Duration(milliseconds: 500));
  //   //     debugPrint('close context');
  //   //     await context.close();
  //   //   }());
  //   //   await context
  //   //       .isCanceledStream
  //   //       // .timeout(
  //   //       //   const Duration(seconds: 1),
  //   //       // )
  //   //       .last;
  //   //   // await for (final v in context.isCanceledStream) {
  //   //   //   debugPrint('isCanceledStream: $v');
  //   //   // }
  //   //   // unawaited(() async {
  //   //   //   await Future<void>.delayed(const Duration(milliseconds: 500));
  //   //   //   debugPrint('close context');
  //   //   //   await context.close();
  //   //   // }());
  //   //   // await stream.last;
  //   //   debugPrint('done');
  //   // }, timeout: const Timeout(Duration(seconds: 5)));

  //   test('cancel', () async {
  //     final stream = Stream.periodic(
  //       const Duration(milliseconds: 100),
  //       (i) {
  //         debugPrint('yield: $i');
  //         return i;
  //       },
  //     ).withContext(context);
  //     unawaited(() async {
  //       await Future<void>.delayed(const Duration(milliseconds: 500));
  //       await context.close();
  //     }());
  //     var received = 0;
  //     try {
  //       await for (final v in stream) {
  //         ++received;
  //         debugPrint('stream: $v');
  //       }
  //       fail('always Nothing');
  //     } on CancellationException catch (e, stackTrace) {
  //       debugPrint('throws CancellationException');
  //       debugPrint('$e, $stackTrace');
  //       expect(received, isNot(equals(0)));
  //     }

  //     await Future<void>.delayed(const Duration(milliseconds: 1000));
  //   });

  //   test('error', () async {
  //     final stream = Stream.periodic(
  //       const Duration(milliseconds: 100),
  //       (i) {
  //         if (i < 10) {
  //           return i;
  //         }
  //         throw Exception('error');
  //       },
  //     ).takeWhile((element) => element < 10).withContext(context);
  //     try {
  //       await for (final v in stream) {
  //         debugPrint('stream: $v');
  //       }
  //       fail('always Nothing');
  //     } on Exception catch (e, stackTrace) {
  //       debugPrint('catch OK: $e, $stackTrace');
  //     }
  //   });

  //   test('cancel with throw', () async {
  //     final stream = context.isCanceledStream.map((event) {
  //       if (event) {
  //         throw CancellationException('${DateTime.now()} cancel');
  //       }
  //       return event;
  //     });
  //     unawaited(() async {
  //       await Future<void>.delayed(const Duration(milliseconds: 500));
  //       await context.close();
  //     }());
  //     try {
  //       await for (final v in stream) {
  //         debugPrint('${DateTime.now()} stream: $v');
  //       }
  //       fail('always Nothing');
  //     } on CancellationException catch (e, stackTrace) {
  //       debugPrint('${DateTime.now()} throws CancellationException');
  //       debugPrint('$e, $stackTrace');
  //     }
  //   });

  //   test('error with close', () async {
  //     final ctx = FutureContext();
  //     final stream1 = () async* {
  //       try {
  //         debugPrint('${DateTime.now()} emit 1-1');
  //         yield "${DateTime.now()} 1-1";
  //         await Future<void>.delayed(const Duration(milliseconds: 1000));
  //         debugPrint('${DateTime.now()} emit 1-2');
  //         yield "${DateTime.now()} 1-2";
  //         await Future<void>.delayed(const Duration(milliseconds: 1000));
  //         debugPrint('${DateTime.now()} emit 1-3');
  //         yield "${DateTime.now()} 1-3";
  //         await Future<void>.delayed(const Duration(milliseconds: 1000));
  //         debugPrint('${DateTime.now()} throw error');
  //         throw Exception('${DateTime.now()} stream1');
  //       } finally {
  //         debugPrint('${DateTime.now()} stream1 finally');
  //       }
  //     }();

  //     try {
  //       unawaited(() async {
  //         await Future<void>.delayed(const Duration(milliseconds: 1500));
  //         debugPrint('${DateTime.now()} cancel');
  //         await ctx.close();
  //       }());
  //       await for (final v in stream1.withContext(
  //         ctx,
  //         receiveAllValues: true,
  //         withDebugLog: true,
  //       )) {
  //         debugPrint('${DateTime.now()} stream1: $v');
  //       }
  //     } on Exception catch (e, stackTrace) {
  //       debugPrint('${DateTime.now()} catch OK: $e\n$stackTrace');
  //     } finally {
  //       debugPrint('${DateTime.now()} finally');
  //       await ctx.close();
  //       await Future<void>.delayed(const Duration(milliseconds: 5000));
  //     }
  //   });
  // });

  group('runtime', () {
    Stream<int> generate() async* {
      try {
        for (var i = 0; i < 100; ++i) {
          debugPrint('emit: $i');
          yield i;
          await Future<void>.delayed(const Duration(milliseconds: 1000));
        }
      } finally {
        debugPrint('emit finally');
      }
    }

    test('stream future', () async {
      try {
        final future = generate()
            .timeout(
              const Duration(seconds: 1),
              onTimeout: (c) {
                c.add(-1);
                c.close();
              },
            )
            // .onErrorReturn(-1)
            .last;
        debugPrint('receive: ${await future}');
      } finally {
        debugPrint('finally');
      }
    }, timeout: const Timeout(Duration(seconds: 10)));

    test('stream generator', () async {
      try {
        await for (final i in generate()) {
          debugPrint('stream: $i');
          return;
          // if (i >= 10) {
          //   debugPrint('abort stream: $i');
          //   return;
          // }
        }
      } finally {
        debugPrint('finally');
      }
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}
