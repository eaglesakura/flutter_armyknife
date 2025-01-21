import 'package:riverpodx/riverpodx.dart';

/// [Provider] のシャットダウン処理を行う関数.
typedef ProviderAsyncDisposeFunction = dynamic Function();

/// [ProviderScope] の非同期処理をサポートするヘルパークラス.
///
/// e.g.
/// ProviderContainer(
///   overrides: [
///    ...ProviderContainerAsyncHelper.inject(),
///   ],
/// );
class ProviderContainerAsyncHelper {
  static final _provider = Provider<ProviderContainerAsyncHelper>(
      (ref) => throw UnimplementedError());

  /// 非同期実行中の解放関数.
  final _disposeTasks = <Future>[];

  /// 非同期実行中の初期化関数.
  var _initializeTasks = <Future>[];

  ProviderContainerAsyncHelper._();

  void _registerInitializeTasks(Future task) {
    _initializeTasks.add(task);
  }

  /// 初期化関数の完了を待つ.
  Future _waitInitializeTasks() async {
    while (true) {
      if (_initializeTasks.isEmpty) {
        return;
      }

      final tasks = _initializeTasks;
      _initializeTasks = <Future>[];
      await Future.wait(tasks);
    }
  }

  static final _inject = [
    _provider.overrideWith((ref) {
      final helper = ProviderContainerAsyncHelper._();
      return helper;
    }),
  ];

  /// [ProviderContainer] に追加する [Override] を取得する.
  static List<Override> inject() {
    return _inject;
  }
}

extension ProviderContainerAsyncExtensions on ProviderContainer {
  /// 非同期の開放関数を含めて解放を行う.
  Future disposeAsync() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    dispose();
    await Future.wait(helper._disposeTasks);
  }

  /// すべての初期化関数が完了するまで待つ.
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._waitInitializeTasks();
  }
}

extension RefAsyncExtensions on Ref {
  /// 非同期の開放関数を登録する.
  void onDisposeAsync(ProviderAsyncDisposeFunction function) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    onDispose(() {
      final result = function();
      if (result is Future) {
        helper._disposeTasks.add(result);
      }
    });
  }

  /// 初期化関数を登録する.
  /// 初期化待ちを行うことができる.
  void registerInitializeTasks(Future task) {
    final helper = read(ProviderContainerAsyncHelper._provider);
    helper._registerInitializeTasks(task);
  }

  /// すべての初期化関数が完了するまで待つ.
  Future waitInitializeTasks() async {
    final helper = read(ProviderContainerAsyncHelper._provider);
    await helper._waitInitializeTasks();
  }
}
