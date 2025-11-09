// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inStockBasesHash() => r'b0040a1955b6080d17831d4db5f71ede6ed35a50';

/// 재고가 있는 재료만 필터링
///
/// Copied from [inStockBases].
@ProviderFor(inStockBases)
final inStockBasesProvider = AutoDisposeFutureProvider<List<Base>>.internal(
  inStockBases,
  name: r'inStockBasesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$inStockBasesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InStockBasesRef = AutoDisposeFutureProviderRef<List<Base>>;
String _$baseListHash() => r'0f3a5fc418855e87a506029a1bf4bbe89c915e86';

/// 재료 목록을 가져오는 Provider
///
/// Copied from [BaseList].
@ProviderFor(BaseList)
final baseListProvider =
    AutoDisposeAsyncNotifierProvider<BaseList, List<Base>>.internal(
  BaseList.new,
  name: r'baseListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$baseListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BaseList = AutoDisposeAsyncNotifier<List<Base>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
