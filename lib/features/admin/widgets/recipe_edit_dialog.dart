import 'package:alcohol/models/drink.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeEditDialog extends ConsumerStatefulWidget {
  final Drink drink;

  const RecipeEditDialog({Key? key, required this.drink}) : super(key: key);

  @override
  ConsumerState<RecipeEditDialog> createState() => _RecipeEditDialogState();
}

class _RecipeEditDialogState extends ConsumerState<RecipeEditDialog> {
  final _recipeService = RecipeService();
  late List<_RecipeEditItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.drink.recipe.elements
        .map((e) => _RecipeEditItem(
              idx: e.idx,
              baseIdx: e.base.idx,
              volume: e.volume,
              volumeController: TextEditingController(text: e.volume),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (var item in _items) {
      item.volumeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final basesAsync = ref.watch(baseListProvider);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.drink.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 레시피 항목 리스트
            Expanded(
              child: basesAsync.when(
                data: (bases) {
                  if (_items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '레시피가 비어있습니다',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '아래 버튼을 눌러 재료를 추가하세요',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final selectedBase =
                          bases.firstWhere((b) => b.idx == item.baseIdx);

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // 재료 선택 Dropdown
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<int>(
                                  value: item.baseIdx,
                                  decoration: const InputDecoration(
                                    labelText: '재료',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  items: bases.map((base) {
                                    return DropdownMenuItem(
                                      value: base.idx,
                                      child: Text(base.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        item.baseIdx = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // 양 입력
                              Expanded(
                                child: TextField(
                                  controller: item.volumeController,
                                  decoration: const InputDecoration(
                                    labelText: '양',
                                    hintText: '30ml',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    item.volume = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),

                              // 삭제 버튼
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).colorScheme.error,
                                onPressed: () {
                                  setState(() {
                                    _items.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('재료를 불러올 수 없습니다')),
              ),
            ),

            // 버튼 영역
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _addRecipeItem(ref),
                    icon: const Icon(Icons.add),
                    label: const Text('재료 추가'),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () => _saveRecipe(context),
                    icon: const Icon(Icons.save),
                    label: const Text('저장'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRecipeItem(WidgetRef ref) async {
    final basesAsync = ref.read(baseListProvider);
    await basesAsync.when(
      data: (bases) async {
        if (bases.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('사용 가능한 재료가 없습니다')),
          );
          return;
        }

        try {
          // API에 새 레시피 항목 추가
          final newElement = await _recipeService.addRecipe(
            widget.drink.idx,
            bases.first.idx,
            '',
          );

          setState(() {
            _items.add(_RecipeEditItem(
              idx: newElement.idx,
              baseIdx: bases.first.idx,
              volume: '',
              volumeController: TextEditingController(),
            ));
          });
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('재료 추가 실패: $e')),
            );
          }
        }
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  Future<void> _saveRecipe(BuildContext context) async {
    try {
      // 각 항목 업데이트
      for (var item in _items) {
        await _recipeService.updateRecipe(
          item.idx,
          item.baseIdx,
          item.volume,
        );
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('레시피가 저장되었습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }
}

class _RecipeEditItem {
  final int idx;
  int baseIdx;
  String volume;
  final TextEditingController volumeController;

  _RecipeEditItem({
    required this.idx,
    required this.baseIdx,
    required this.volume,
    required this.volumeController,
  });
}
