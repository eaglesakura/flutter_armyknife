import 'package:time_machine/time_machine.dart';

/// [Clock] のDelegateオブジェクト.
/// 指定した処理のみを行い、他の処理は元の[Clock]に委譲する.
class ClockDelegate implements Clock {
  final Clock origin;

  /// [getCurrentInstant] の処理を委譲する.
  final Instant Function()? getCurrentInstantDelegate;

  ClockDelegate({
    Clock? origin,
    this.getCurrentInstantDelegate,
  }) : origin = origin ?? SystemClock.instance;

  @override
  Instant getCurrentInstant() {
    if (getCurrentInstantDelegate != null) {
      return getCurrentInstantDelegate!();
    }
    return origin.getCurrentInstant();
  }

  @override
  Future<ZonedClock> inTzdbSystemDefaultZone() {
    return origin.inTzdbSystemDefaultZone();
  }

  @override
  ZonedClock inUtc() {
    return origin.inUtc();
  }

  @override
  ZonedClock inZone(DateTimeZone zone, [CalendarSystem? calendar]) {
    return origin.inZone(zone, calendar);
  }
}
