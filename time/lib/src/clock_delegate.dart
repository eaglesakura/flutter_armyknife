import 'package:time_machine/time_machine.dart';

/// [Clock] のDelegateオブジェクト.
///
/// 指定した処理のみを行い、他の処理は元の[Clock]に委譲する.
/// テストで現在時刻だけ差し替える用途を想定する.
class ClockDelegate implements Clock {
  /// 委譲先の元時計.
  ///
  /// 未指定時は [SystemClock.instance] が使われる.
  final Clock origin;

  /// [getCurrentInstant] の処理を委譲する.
  ///
  /// `null` のときは [origin] の実装をそのまま呼ぶ.
  final Instant Function()? getCurrentInstantDelegate;

  /// 委譲先と差し替え関数を受け取る.
  ///
  /// [origin] が省略された場合はシステム時計を使う.
  /// [getCurrentInstantDelegate] を渡すと現在時刻の取得だけ差し替えられる.
  ///
  /// Example:
  /// ```dart
  /// final fixed = Instant.fromEpochMilliseconds(0);
  /// final clock = ClockDelegate(
  ///   getCurrentInstantDelegate: () => fixed,
  /// );
  /// final now = clock.getCurrentInstant();
  /// ```
  ClockDelegate({
    Clock? origin,
    this.getCurrentInstantDelegate,
  }) : origin = origin ?? SystemClock.instance;

  /// 現在時刻を返す.
  ///
  /// [getCurrentInstantDelegate] があればそれを優先し、なければ [origin] へ委譲する.
  ///
  /// Example:
  /// ```dart
  /// final clock = ClockDelegate();
  /// final now = clock.getCurrentInstant();
  /// ```
  @override
  Instant getCurrentInstant() {
    if (getCurrentInstantDelegate != null) {
      return getCurrentInstantDelegate!();
    }
    return origin.getCurrentInstant();
  }

  /// TZDBのシステム既定ゾーン付き時計を返す.
  ///
  /// [origin] へそのまま委譲する.
  ///
  /// Example:
  /// ```dart
  /// final zoned = await ClockDelegate().inTzdbSystemDefaultZone();
  /// ```
  @override
  Future<ZonedClock> inTzdbSystemDefaultZone() {
    return origin.inTzdbSystemDefaultZone();
  }

  /// UTCゾーン付き時計を返す.
  ///
  /// [origin] へそのまま委譲する.
  ///
  /// Example:
  /// ```dart
  /// final utc = ClockDelegate().inUtc();
  /// ```
  @override
  ZonedClock inUtc() {
    return origin.inUtc();
  }

  /// 指定ゾーン付き時計を返す.
  ///
  /// [zone] は対象タイムゾーン、[calendar] は任意の暦体系.
  /// [origin] へそのまま委譲する.
  ///
  /// Example:
  /// ```dart
  /// final tokyo = ClockDelegate().inZone(DateTimeZone.utc);
  /// ```
  @override
  ZonedClock inZone(DateTimeZone zone, [CalendarSystem? calendar]) {
    return origin.inZone(zone, calendar);
  }
}
