import 'package:alcohol/core/providers/service_providers.dart';
import 'package:alcohol/models/drink.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drink_providers.g.dart';

/// 칵테일 목록을 가져오는 Provider
@riverpod
class DrinkList extends _$DrinkList {
  @override
  Future<List<Drink>> build() async {
    final drinkService = ref.read(drinkServiceProvider);
    return drinkService.fetchDrinks();
  }

  /// 칵테일 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final drinkService = ref.read(drinkServiceProvider);
      return drinkService.fetchDrinks();
    });
  }

  /// 새 칵테일 추가
  Future<Drink?> addDrink(String name, String img, String desc) async {
    final drinkService = ref.read(drinkServiceProvider);
    final newDrink = await drinkService.addDrink(name, img, desc);

    state = state.whenData((drinks) => [...drinks, newDrink]);

    return newDrink;
  }
}

/// 텍스트 필터 상태
@riverpod
class TextFilter extends _$TextFilter {
  @override
  String build() => '';

  void update(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

/// 재료 필터 상태 (선택된 재료 ID 세트)
@riverpod
class BaseFilter extends _$BaseFilter {
  @override
  Set<int> build() => {};

  void toggle(int baseIdx) {
    final newSet = Set<int>.from(state);
    if (newSet.contains(baseIdx)) {
      newSet.remove(baseIdx);
    } else {
      newSet.add(baseIdx);
    }
    state = newSet;
  }

  void clear() {
    state = {};
  }
}

/// 필터링된 칵테일 목록 (computed provider)
@riverpod
Future<List<Drink>> filteredDrinks(Ref ref) async {
  final drinksAsync = ref.watch(drinkListProvider);
  final textFilter = ref.watch(textFilterProvider);
  final baseFilter = ref.watch(baseFilterProvider);

  return drinksAsync.when(
    data: (drinks) {
      var filtered = drinks.where((drink) => drink.recipe.available).toList();

      // 텍스트 필터 적용
      if (textFilter.isNotEmpty) {
        filtered = filtered
            .where((drink) => drink.name.contains(textFilter))
            .toList();
      }

      // 재료 필터 적용
      if (baseFilter.isNotEmpty) {
        filtered = filtered.where((drink) {
          return baseFilter.any((baseIdx) => drink.baseContains(baseIdx));
        }).toList();
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// 현재 선택된 칵테일 인덱스
@riverpod
class CurrentDrinkIndex extends _$CurrentDrinkIndex {
  @override
  int build() => 0;

  void update(int index) {
    state = index;
  }
}

/// 현재 선택된 칵테일 ID (필터링에 영향받지 않음)
@riverpod
class CurrentDrinkId extends _$CurrentDrinkId {
  @override
  int? build() => null;

  void update(int? drinkId) {
    state = drinkId;
  }
}

/// 현재 선택된 칵테일
@riverpod
Future<Drink?> currentDrink(Ref ref) async {
  final drinkId = ref.watch(currentDrinkIdProvider);

  // ID가 설정되지 않았으면 인덱스 기반으로 fallback
  if (drinkId == null) {
    final drinks = await ref.watch(filteredDrinksProvider.future);
    final index = ref.watch(currentDrinkIndexProvider);

    if (drinks.isEmpty) return null;
    if (index >= drinks.length) return drinks.last;
    return drinks[index];
  }

  // ID 기반으로 전체 목록에서 칵테일 찾기
  final allDrinks = await ref.watch(drinkListProvider.future);
  try {
    return allDrinks.firstWhere((drink) => drink.idx == drinkId);
  } catch (e) {
    return null;
  }
}
