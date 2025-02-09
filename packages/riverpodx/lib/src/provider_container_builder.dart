import 'package:riverpodx/riverpodx.dart';

/// [ProviderContainer] の生成をサポートするBuilderオブジェクト.
/// 依存ツリーを構築してから、[ProviderContainer] を生成する.
class ProviderContainerBuilder {
  final Map<Provider, Override> _overrides = {};

  ProviderContainerBuilder();

  /// [ProviderContainer] に追加する [Override] を登録する.
  /// 同じProviderに対して操作が行われた場合、上書きされる.
  ProviderContainerBuilder add<T>(
    Provider<T> provider,
    Override Function(Provider<T> provider) override,
  ) {
    _overrides[provider] = override(provider);
    // ignore: avoid_returning_this
    return this;
  }

  /// [stub] 内容を [override] で上書きする.
  /// DIでインターフェースと実装を切り分けた場合に使用する.
  ProviderContainerBuilder inject<T, T2 extends T>(
    Provider<T> stub,
    Provider<T2> override,
  ) {
    return add(
      stub,
      (provider) => provider.overrideWith(
        (ref) => ref.watch(override),
      ),
    );
  }

  /// 登録済みの [Provider] と [Override] のリストを取得する.
  List<Override> get overrides => _overrides.values.toList();

  /// [ProviderContainer] を生成する.
  ///
  /// [overrides] には、更に別な [Override] を追加することができる.
  ProviderContainer build({
    List<Override> overrides = const [],
  }) {
    return ProviderContainer(
      overrides: [
        ...this.overrides,
        ...overrides,
      ],
    );
  }
}
