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
///
/// 필터링은 순수 동기 연산이므로 Future로 감싸지 않는다.
/// (async였을 때는 키 입력마다 loading 상태를 거치며 화면이 리빌드됐음)
@riverpod
List<Drink> filteredDrinks(Ref ref) {
  final drinks = ref.watch(drinkListProvider).value ?? [];
  final textFilter = ref.watch(textFilterProvider);
  final baseFilter = ref.watch(baseFilterProvider);

  var filtered = drinks;

  // 텍스트 필터 적용
  if (textFilter.isNotEmpty) {
    filtered =
        filtered.where((drink) => drink.name.contains(textFilter)).toList();
  }

  // 재료 필터 적용
  if (baseFilter.isNotEmpty) {
    // 선택된 재료를 모두 포함하는 칵테일만 필터링
    filtered = filtered.where((drink) {
      return baseFilter.every((baseIdx) => drink.baseContains(baseIdx));
    }).toList();
  } else {
    // 재료 필터가 없을 때는 제조 가능한 것만 표시
    filtered = filtered.where((drink) => drink.recipe.available).toList();
  }

  return filtered;
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
Drink? currentDrink(Ref ref) {
  final drinkId = ref.watch(currentDrinkIdProvider);

  // ID가 설정되지 않았으면 인덱스 기반으로 fallback
  if (drinkId == null) {
    final drinks = ref.watch(filteredDrinksProvider);
    final index = ref.watch(currentDrinkIndexProvider);

    if (drinks.isEmpty) return null;
    if (index >= drinks.length) return drinks.last;
    return drinks[index];
  }

  // ID 기반으로 전체 목록에서 칵테일 찾기
  final allDrinks = ref.watch(drinkListProvider).value ?? [];
  for (final drink in allDrinks) {
    if (drink.idx == drinkId) return drink;
  }
  return null;
}
