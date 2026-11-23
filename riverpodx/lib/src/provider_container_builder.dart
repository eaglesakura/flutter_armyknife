/// 旧経路向けのProviderContainerBuilder再エクスポート.
///
/// 実装本体は `package:riverpod_container_builder` へ移管済み.
/// 新規コードでは直接そちらを参照すること.
library;

@Deprecated(
  'Use package:riverpod_container_builder/riverpod_container_builder.dart. '
  'ProviderContainerBuilder has moved out of armyknife_riverpodx.',
)
export 'package:riverpod_container_builder/riverpod_container_builder.dart'
    show ProviderContainerBuilder;
