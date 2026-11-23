import 'package:time_machine/time_machine.dart';

/// [Instant] 向けの補助定数・ヘルパー.
final class InstantX {
  /// Unixエポック（1970年1月1日 00:00:00 UTC）を表す時刻.
  static final epoch = Instant.fromEpochMilliseconds(0);

  /// インスタンス化を禁止する.
  ///
  /// Example:
  /// ```dart
  /// final zero = InstantX.epoch;
  /// ```
  const InstantX._();

  /// 現在のミリ秒単位の時刻を取得する.
  ///
  /// ナノ秒以下を切り捨て、ミリ秒精度の [Instant] を返す.
  ///
  /// Example:
  /// ```dart
  /// final now = InstantX.nowMilliSeconds();
  /// ```
  static Instant nowMilliSeconds() {
    return Instant.fromEpochMilliseconds(
      Instant.now().epochMilliseconds,
    );
  }
}
