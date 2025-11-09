// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredDrinksHash() => r'604210c0dc2eb049b23f050ebbb0e487dfdca86a';

/// 필터링된 칵테일 목록 (computed provider)
///
/// Copied from [filteredDrinks].
@ProviderFor(filteredDrinks)
final filteredDrinksProvider = AutoDisposeFutureProvider<List<Drink>>.internal(
  filteredDrinks,
  name: r'filteredDrinksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredDrinksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredDrinksRef = AutoDisposeFutureProviderRef<List<Drink>>;
String _$currentDrinkHash() => r'bad7a11c3130c93c56c8e0dc08cdb8492cf88a92';

/// 현재 선택된 칵테일
///
/// Copied from [currentDrink].
@ProviderFor(currentDrink)
final currentDrinkProvider = AutoDisposeFutureProvider<Drink?>.internal(
  currentDrink,
  name: r'currentDrinkProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentDrinkHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentDrinkRef = AutoDisposeFutureProviderRef<Drink?>;
String _$drinkListHash() => r'64a328a8e86921656766844e8dabc19737a3f5c3';

/// 칵테일 목록을 가져오는 Provider
///
/// Copied from [DrinkList].
@ProviderFor(DrinkList)
final drinkListProvider =
    AutoDisposeAsyncNotifierProvider<DrinkList, List<Drink>>.internal(
  DrinkList.new,
  name: r'drinkListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$drinkListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DrinkList = AutoDisposeAsyncNotifier<List<Drink>>;
String _$textFilterHash() => r'b9f8350a11879519b4448bc55688523194c50fcc';

/// 텍스트 필터 상태
///
/// Copied from [TextFilter].
@ProviderFor(TextFilter)
final textFilterProvider =
    AutoDisposeNotifierProvider<TextFilter, String>.internal(
  TextFilter.new,
  name: r'textFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$textFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TextFilter = AutoDisposeNotifier<String>;
String _$baseFilterHash() => r'72874992fa93ad69eaa67bbb578b7395975e8f08';

/// 재료 필터 상태 (선택된 재료 ID 세트)
///
/// Copied from [BaseFilter].
@ProviderFor(BaseFilter)
final baseFilterProvider =
    AutoDisposeNotifierProvider<BaseFilter, Set<int>>.internal(
  BaseFilter.new,
  name: r'baseFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$baseFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BaseFilter = AutoDisposeNotifier<Set<int>>;
String _$currentDrinkIndexHash() => r'4e370f16de680e3a87d2b74585ae64fc689235c4';

/// 현재 선택된 칵테일 인덱스
///
/// Copied from [CurrentDrinkIndex].
@ProviderFor(CurrentDrinkIndex)
final currentDrinkIndexProvider =
    AutoDisposeNotifierProvider<CurrentDrinkIndex, int>.internal(
  CurrentDrinkIndex.new,
  name: r'currentDrinkIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDrinkIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentDrinkIndex = AutoDisposeNotifier<int>;
String _$currentDrinkIdHash() => r'04e5a5bbfb033b6808324d408f681794efc6dc4c';

/// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)
///
/// Copied from [CurrentDrinkId].
@ProviderFor(CurrentDrinkId)
final currentDrinkIdProvider =
    AutoDisposeNotifierProvider<CurrentDrinkId, int?>.internal(
  CurrentDrinkId.new,
  name: r'currentDrinkIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentDrinkIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentDrinkId = AutoDisposeNotifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
