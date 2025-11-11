// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drink_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 칵테일 목록을 가져오는 Provider

@ProviderFor(DrinkList)
const drinkListProvider = DrinkListProvider._();

/// 칵테일 목록을 가져오는 Provider
final class DrinkListProvider
    extends $AsyncNotifierProvider<DrinkList, List<Drink>> {
  /// 칵테일 목록을 가져오는 Provider
  const DrinkListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'drinkListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$drinkListHash();

  @$internal
  @override
  DrinkList create() => DrinkList();
}

String _$drinkListHash() => r'503378c718f5c8774d7dc7f745c47e42b00f05a8';

/// 칵테일 목록을 가져오는 Provider

abstract class _$DrinkList extends $AsyncNotifier<List<Drink>> {
  FutureOr<List<Drink>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Drink>>, List<Drink>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Drink>>, List<Drink>>,
        AsyncValue<List<Drink>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

/// 텍스트 필터 상태

@ProviderFor(TextFilter)
const textFilterProvider = TextFilterProvider._();

/// 텍스트 필터 상태
final class TextFilterProvider extends $NotifierProvider<TextFilter, String> {
  /// 텍스트 필터 상태
  const TextFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'textFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$textFilterHash();

  @$internal
  @override
  TextFilter create() => TextFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$textFilterHash() => r'b9f8350a11879519b4448bc55688523194c50fcc';

/// 텍스트 필터 상태

abstract class _$TextFilter extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// 재료 필터 상태 (선택된 재료 ID 세트)

@ProviderFor(BaseFilter)
const baseFilterProvider = BaseFilterProvider._();

/// 재료 필터 상태 (선택된 재료 ID 세트)
final class BaseFilterProvider extends $NotifierProvider<BaseFilter, Set<int>> {
  /// 재료 필터 상태 (선택된 재료 ID 세트)
  const BaseFilterProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'baseFilterProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$baseFilterHash();

  @$internal
  @override
  BaseFilter create() => BaseFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<int>>(value),
    );
  }
}

String _$baseFilterHash() => r'72874992fa93ad69eaa67bbb578b7395975e8f08';

/// 재료 필터 상태 (선택된 재료 ID 세트)

abstract class _$BaseFilter extends $Notifier<Set<int>> {
  Set<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<int>, Set<int>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<int>, Set<int>>, Set<int>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// 필터링된 칵테일 목록 (computed provider)

@ProviderFor(filteredDrinks)
const filteredDrinksProvider = FilteredDrinksProvider._();

/// 필터링된 칵테일 목록 (computed provider)

final class FilteredDrinksProvider extends $FunctionalProvider<
        AsyncValue<List<Drink>>, List<Drink>, FutureOr<List<Drink>>>
    with $FutureModifier<List<Drink>>, $FutureProvider<List<Drink>> {
  /// 필터링된 칵테일 목록 (computed provider)
  const FilteredDrinksProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'filteredDrinksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$filteredDrinksHash();

  @$internal
  @override
  $FutureProviderElement<List<Drink>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Drink>> create(Ref ref) {
    return filteredDrinks(ref);
  }
}

String _$filteredDrinksHash() => r'6a91ec56e92257503521740f62c6cf8868f31d85';

/// 현재 선택된 칵테일 인덱스

@ProviderFor(CurrentDrinkIndex)
const currentDrinkIndexProvider = CurrentDrinkIndexProvider._();

/// 현재 선택된 칵테일 인덱스
final class CurrentDrinkIndexProvider
    extends $NotifierProvider<CurrentDrinkIndex, int> {
  /// 현재 선택된 칵테일 인덱스
  const CurrentDrinkIndexProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentDrinkIndexProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentDrinkIndexHash();

  @$internal
  @override
  CurrentDrinkIndex create() => CurrentDrinkIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentDrinkIndexHash() => r'4e370f16de680e3a87d2b74585ae64fc689235c4';

/// 현재 선택된 칵테일 인덱스

abstract class _$CurrentDrinkIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)

@ProviderFor(CurrentDrinkId)
const currentDrinkIdProvider = CurrentDrinkIdProvider._();

/// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)
final class CurrentDrinkIdProvider
    extends $NotifierProvider<CurrentDrinkId, int?> {
  /// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)
  const CurrentDrinkIdProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentDrinkIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentDrinkIdHash();

  @$internal
  @override
  CurrentDrinkId create() => CurrentDrinkId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$currentDrinkIdHash() => r'04e5a5bbfb033b6808324d408f681794efc6dc4c';

/// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)

abstract class _$CurrentDrinkId extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int?, int?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<int?, int?>, int?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

/// 현재 선택된 칵테일

@ProviderFor(currentDrink)
const currentDrinkProvider = CurrentDrinkProvider._();

/// 현재 선택된 칵테일

final class CurrentDrinkProvider
    extends $FunctionalProvider<AsyncValue<Drink?>, Drink?, FutureOr<Drink?>>
    with $FutureModifier<Drink?>, $FutureProvider<Drink?> {
  /// 현재 선택된 칵테일
  const CurrentDrinkProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'currentDrinkProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$currentDrinkHash();

  @$internal
  @override
  $FutureProviderElement<Drink?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Drink?> create(Ref ref) {
    return currentDrink(ref);
  }
}

String _$currentDrinkHash() => r'59f1b7102778aab6ddf48eaec80b0c18589a1c6a';
