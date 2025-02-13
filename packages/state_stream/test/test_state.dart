import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_state.freezed.dart';

@freezed
class TestState with _$TestState {
  const factory TestState({
    @Default(0) int integer,
    @Default('') String string,
  }) = _TestState;

  const TestState._();
}
