import 'package:alcohol/core/providers/service_providers.dart';
import 'package:alcohol/models/base.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'base_providers.g.dart';

/// 재료 목록을 가져오는 Provider
@riverpod
class BaseList extends _$BaseList {
  @override
  Future<List<Base>> build() async {
    final baseService = ref.read(baseServiceProvider);
    return baseService.fetchBases();
  }

  /// 재료 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final baseService = ref.read(baseServiceProvider);
      return baseService.fetchBases();
    });
  }

  /// 새 재료 추가
  Future<void> addBase(String name, bool inStock) async {
    final baseService = ref.read(baseServiceProvider);
    final newBase = await baseService.addBase(name, inStock);

    state = state.whenData((bases) => [...bases, newBase]);
  }

  /// 재료 재고 상태 업데이트
  Future<void> updateInStock(int idx, bool inStock) async {
    final baseService = ref.read(baseServiceProvider);
    await baseService.updateBaseInStock(idx, inStock);

    // 로컬 상태 업데이트
    state = state.whenData((bases) {
      return bases.map((base) {
        if (base.idx == idx) {
          return base.copyWith(inStock: inStock);
        }
        return base;
      }).toList();
    });
  }

  /// 재료 이름 업데이트
  Future<void> updateName(int idx, String name) async {
    final baseService = ref.read(baseServiceProvider);
    await baseService.updateBaseName(idx, name);

    // 로컬 상태 업데이트
    state = state.whenData((bases) {
      return bases.map((base) {
        if (base.idx == idx) {
          return base.copyWith(name: name);
        }
        return base;
      }).toList();
    });
  }
}

/// 재고가 있는 재료만 필터링
@riverpod
Future<List<Base>> inStockBases(Ref ref) async {
  final basesAsync = ref.watch(baseListProvider);

  return basesAsync.when(
    data: (bases) => bases.where((base) => base.inStock).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}
