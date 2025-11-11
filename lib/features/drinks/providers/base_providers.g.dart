// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 재료 목록을 가져오는 Provider

@ProviderFor(BaseList)
const baseListProvider = BaseListProvider._();

/// 재료 목록을 가져오는 Provider
final class BaseListProvider
    extends $AsyncNotifierProvider<BaseList, List<Base>> {
  /// 재료 목록을 가져오는 Provider
  const BaseListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'baseListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$baseListHash();

  @$internal
  @override
  BaseList create() => BaseList();
}

String _$baseListHash() => r'0f3a5fc418855e87a506029a1bf4bbe89c915e86';

/// 재료 목록을 가져오는 Provider

abstract class _$BaseList extends $AsyncNotifier<List<Base>> {
  FutureOr<List<Base>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Base>>, List<Base>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Base>>, List<Base>>,
        AsyncValue<List<Base>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// 재고가 있는 재료만 필터링

@ProviderFor(inStockBases)
const inStockBasesProvider = InStockBasesProvider._();

/// 재고가 있는 재료만 필터링

final class InStockBasesProvider extends $FunctionalProvider<
        AsyncValue<List<Base>>, List<Base>, FutureOr<List<Base>>>
    with $FutureModifier<List<Base>>, $FutureProvider<List<Base>> {
  /// 재고가 있는 재료만 필터링
  const InStockBasesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'inStockBasesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$inStockBasesHash();

  @$internal
  @override
  $FutureProviderElement<List<Base>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Base>> create(Ref ref) {
    return inStockBases(ref);
  }
}

String _$inStockBasesHash() => r'17f800546fb47fb321e4de576211348ad2ab4d68';
