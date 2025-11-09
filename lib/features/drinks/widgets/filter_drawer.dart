import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterDrawer extends ConsumerWidget {
  const FilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(baseListProvider);
    final baseFilter = ref.watch(baseFilterProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '재료 필터',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  if (baseFilter.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        ref.read(baseFilterProvider.notifier).clear();
                      },
                      child: const Text('초기화'),
                    ),
                ],
              ),
            ),
            const Divider(),

            // 재료 목록
            Expanded(
              child: basesAsync.when(
                data: (bases) {
                  final inStockBases =
                      bases.where((base) => base.inStock).toList();

                  if (inStockBases.isEmpty) {
                    return const Center(
                      child: Text('재고가 있는 재료가 없습니다'),
                    );
                  }

                  return ListView.builder(
                    itemCount: inStockBases.length,
                    itemBuilder: (context, index) {
                      final base = inStockBases[index];
                      final isSelected = baseFilter.contains(base.idx);

                      return CheckboxListTile(
                        title: Text(base.name),
                        value: isSelected,
                        onChanged: (bool? value) {
                          ref
                              .read(baseFilterProvider.notifier)
                              .toggle(base.idx);
                        },
                        secondary: Icon(
                          Icons.liquor,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 48),
                      const SizedBox(height: 16),
                      Text('오류: $error'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          ref.invalidate(baseListProvider);
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 정보
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Text(
                '선택된 재료: ${baseFilter.length}개',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
