import 'package:time_machine/time_machine.dart';

final class InstantX {
  /// Unixエポック（1970年1月1日 00:00:00 UTC）を表す時刻.
  static final epoch = Instant.fromEpochMilliseconds(0);

  const InstantX._();

  /// 現在のミリ秒単位の時刻を取得する.
  static Instant nowMilliSeconds() {
    return Instant.fromEpochMilliseconds(
      Instant.now().epochMilliseconds,
    );
  }
}
