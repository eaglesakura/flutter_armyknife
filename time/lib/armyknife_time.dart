/// 時刻操作の公開APIを集約する.
///
/// `time_machine` の主要型と、時計差し替え・Instant補助を再エクスポートする.
library;

export 'package:time_machine/time_machine.dart' show Instant, Time, Clock;
export 'src/clock_delegate.dart';
export 'src/instantx.dart';
