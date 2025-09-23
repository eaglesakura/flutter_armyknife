import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_lifecycle_detector/route_lifecycle_detector.dart';

void main() {
  testWidgets('build()中でも取得できる', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [
          RouteLifecycleDetector.navigatorObserver,
        ],
        home: Scaffold(
          body: Builder(
            builder: (context) {
              expect(
                RouteLifecycle.of(context),
                isNot(equals(RouteLifecycle.destroyed)),
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  });
}
