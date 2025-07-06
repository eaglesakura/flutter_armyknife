import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// FlutterのUnitTest($ flutter test)として実行中であればtrueを返却する.
///
/// https://github.com/vivitainc/flutter_armyknife_stdlib/blob/main/lib/src/environments.dart
bool get isFlutterTesting =>
    !kIsWeb && io.Platform.environment.containsKey('FLUTTER_TEST');

/// 次の描画フレームタイミングまで待機する.
Future vsync() async {
  final done = Completer();
  WidgetsBinding.instance.scheduleFrameCallback((_) {
    done.complete();
  });
  return done.future;
}
