import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// FlutterのUnitTest($ flutter test)として実行中であればtrueを返却する.
///
/// https://github.com/vivitainc/flutter_armyknife_stdlib/blob/main/lib/src/environments.dart
bool get isFlutterTesting =>
    !kIsWeb && io.Platform.environment.containsKey('FLUTTER_TEST');

/// 次の描画フレームタイミングまで待機する.
///
/// [WidgetsBinding]のフレームコールバックで次フレームを待ち、
/// UI更新後の検証や座標取得前の同期に使う.
///
/// Example:
/// ```dart
/// await vsync();
/// ```
Future vsync() async {
  final done = Completer();
  WidgetsBinding.instance.scheduleFrameCallback((_) {
    done.complete();
  });
  return done.future;
}
