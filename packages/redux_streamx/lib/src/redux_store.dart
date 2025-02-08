import 'package:redux_stream2/redux_stream2.dart' as rs2;
import 'package:redux_streamx/src/state_stream.dart';

/// Reduxの状態を表す型.
typedef ReduxState = rs2.ReduxState;

/// Reduxのアクションを表す型.
abstract class ReduxStore<T extends ReduxState> implements StateStream<T> {
  /// このStoreが破棄済みであるかどうかを取得する.
  /// trueを返却するとき、もうActionを行うことはできない.
  ///
  /// ただし、破棄済みであっても完全に処理が終了していない場合がある.
  bool get isDisposed;

  /// このStoreが有効である場合にtrueを返却する.
  bool get isNotDisposed;

  /// 現在積まれている更新処理をすべて完了させ、最終状態を取得する.
  Future<T> get stateAsync;

  /// ストリームを閉じる.
  Future close();
}
