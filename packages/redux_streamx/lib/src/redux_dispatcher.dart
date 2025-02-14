import 'package:redux_streamx/src/redux_store.dart';

/// Redux設計におけるDispatcherのインターフェース.
@Deprecated('Use state_stream package')
abstract class ReduxDispatcher<T extends ReduxState> {
  /// Storeを取得する.
  ReduxStore<T> get store;

  /// Dispatcher削除.
  Future dispose();
}
