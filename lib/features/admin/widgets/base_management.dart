import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseManagement extends ConsumerWidget {
  const BaseManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(baseListProvider);

    return Scaffold(
      body: basesAsync.when(
        data: (bases) {
          if (bases.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.liquor_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 재료가 없습니다',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아래 + 버튼을 눌러 재료를 추가하세요',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(baseListProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bases.length,
              itemBuilder: (context, index) {
                final base = bases[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: base.inStock
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.liquor,
                        color: base.inStock
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    title: TextFormField(
                      initialValue: base.name,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '재료 이름',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty && value != base.name) {
                          ref
                              .read(baseListProvider.notifier)
                              .updateName(base.idx, value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${base.name} → $value 변경됨')),
                          );
                        }
                      },
                    ),
                    trailing: Switch(
                      value: base.inStock,
                      onChanged: (value) {
                        ref
                            .read(baseListProvider.notifier)
                            .updateInStock(base.idx, value);
                        // 칵테일 목록도 새로고침하여 available 상태 업데이트
                        ref.invalidate(drinkListProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${base.name}: ${value ? "재고 있음" : "재고 없음"}',
                            ),
                          ),
                        );
                      },
                    ),
                    subtitle: Text(
                      base.inStock ? '재고 있음' : '재고 없음',
                      style: TextStyle(
                        color: base.inStock
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('오류: $error'),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  ref.invalidate(baseListProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddBaseDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('재료 추가'),
      ),
    );
  }

  void _showAddBaseDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    bool inStock = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('새 재료 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '재료 이름',
                  hintText: '예: 보드카, 럼, 진 등',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('재고 여부'),
                value: inStock,
                onChanged: (value) {
                  setState(() {
                    inStock = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    await ref
                        .read(baseListProvider.notifier)
                        .addBase(nameController.text, inStock);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${nameController.text} 추가됨'),
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('추가'),
            ),
          ],
        ),
      ),
    );
  }
}
