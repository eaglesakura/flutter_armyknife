import 'package:time_machine/time_machine.dart';

final class InstantX {
  const InstantX._();

  /// 現在のミリ秒単位の時刻を取得する.
  static Instant nowMilliSeconds() {
    return Instant.fromEpochMilliseconds(
      Instant.now().epochMilliseconds,
    );
  }
}
