import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_container_builder/riverpod_container_builder.dart';

final _valueProvider = Provider<int>((ref) => 0);
final _stubProvider = Provider<String>((ref) => 'stub');
final _implProvider = Provider<String>((ref) => 'impl');
final _otherProvider = Provider<bool>((ref) => false);

void main() {
  test('add で Provider を差し替えられる', () {
    final container = ProviderContainerBuilder()
        .add(_valueProvider, (p) => p.overrideWith((ref) => 42))
        .build();
    addTearDown(container.dispose);

    expect(container.read(_valueProvider), 42);
  });

  test('override で同一 Provider は後勝ちになる', () {
    final builder = ProviderContainerBuilder()
        .override(
          _valueProvider,
          _valueProvider.overrideWith((ref) => 1),
        )
        .override(
          _valueProvider,
          _valueProvider.overrideWith((ref) => 2),
        );

    final container = builder.build();
    addTearDown(container.dispose);

    expect(container.read(_valueProvider), 2);
  });

  test('inject で別 Provider の値を注入できる', () {
    final container = ProviderContainerBuilder()
        .inject(_stubProvider, _implProvider)
        .build();
    addTearDown(container.dispose);

    expect(container.read(_stubProvider), 'impl');
  });

  test('injectValue で固定値を注入できる', () {
    final container = ProviderContainerBuilder()
        .injectValue(_valueProvider, 99)
        .build();
    addTearDown(container.dispose);

    expect(container.read(_valueProvider), 99);
  });

  test('addOverride で Override を追加できる', () {
    final container = ProviderContainerBuilder()
        .addOverride(_otherProvider.overrideWith((ref) => true))
        .build();
    addTearDown(container.dispose);

    expect(container.read(_otherProvider), isTrue);
  });

  test('addOverrides で複数 Override を一括追加できる', () {
    final container = ProviderContainerBuilder().addOverrides([
      _valueProvider.overrideWith((ref) => 7),
      _otherProvider.overrideWith((ref) => true),
    ]).build();
    addTearDown(container.dispose);

    expect(container.read(_valueProvider), 7);
    expect(container.read(_otherProvider), isTrue);
  });

  test('overrides getter は _overrides の後に providerOverrides を返す', () {
    final builder = ProviderContainerBuilder()
        .addOverride(_otherProvider.overrideWith((ref) => true))
        .injectValue(_valueProvider, 3);

    expect(builder.overrides, hasLength(2));
  });

  test('build(overrides:) で追加 Override を適用できる', () {
    final container = ProviderContainerBuilder().build(
      overrides: [
        _valueProvider.overrideWith((ref) => 11),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(_valueProvider), 11);
  });

  test('build(parent:) で親の値を継承できる', () {
    final parent = ProviderContainerBuilder()
        .injectValue(_valueProvider, 5)
        .build();
    addTearDown(parent.dispose);

    final child = ProviderContainerBuilder().build(parent: parent);
    addTearDown(child.dispose);

    expect(child.read(_valueProvider), 5);
  });

  test('build(parent:) の子 Override が親より優先される', () {
    final parent = ProviderContainerBuilder()
        .injectValue(_valueProvider, 5)
        .build();
    addTearDown(parent.dispose);

    final child = ProviderContainerBuilder()
        .injectValue(_valueProvider, 8)
        .build(parent: parent);
    addTearDown(child.dispose);

    expect(parent.read(_valueProvider), 5);
    expect(child.read(_valueProvider), 8);
  });

  test('メソッドチェーンは ProviderContainerBuilder を返す', () {
    final builder = ProviderContainerBuilder();

    expect(
      builder.add(_valueProvider, (p) => p.overrideWith((ref) => 1)),
      same(builder),
    );
    expect(
      builder.addOverride(_otherProvider.overrideWith((ref) => true)),
      same(builder),
    );
    expect(
      builder.addOverrides([_stubProvider.overrideWith((ref) => 'x')]),
      same(builder),
    );
    expect(
      builder.override(
        _stubProvider,
        _stubProvider.overrideWith((ref) => 'y'),
      ),
      same(builder),
    );
    expect(builder.inject(_stubProvider, _implProvider), same(builder));
    expect(builder.injectValue(_valueProvider, 0), same(builder));
  });
}
