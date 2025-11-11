import 'package:alcohol/models/drink.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:alcohol/services/recipe_service.dart';
import 'package:alcohol/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class RecipeEditDialog extends ConsumerStatefulWidget {
  final Drink drink;

  const RecipeEditDialog({Key? key, required this.drink}) : super(key: key);

  @override
  ConsumerState<RecipeEditDialog> createState() => _RecipeEditDialogState();
}

class _RecipeEditDialogState extends ConsumerState<RecipeEditDialog> {
  final _recipeService = RecipeService();
  final _imageUploadService = ImageUploadService();
  List<_RecipeEditItem> _items = [];

  Uint8List? _selectedImageBytes;
  String? _selectedFileName;
  bool _isUploadingImage = false;

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

            // 이미지 섹션
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.image, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '칵테일 이미지',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_selectedImageBytes != null)
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _selectedImageBytes!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedImageBytes = null;
                                _selectedFileName = null;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  else if (widget.drink.img.isNotEmpty)
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.drink.img,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 48),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '이미지 없음',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _isUploadingImage ? null : _pickImage,
                    icon: const Icon(Icons.upload),
                    label: const Text('이미지 변경'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
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
                    onPressed: _isUploadingImage ? null : () => _saveRecipe(context),
                    icon: _isUploadingImage
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isUploadingImage ? '업로드 중...' : '저장'),
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

  Future<void> _pickImage() async {
    try {
      // HTML input element 생성
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      await uploadInput.onChange.first;

      final files = uploadInput.files;
      if (files == null || files.isEmpty) {
        return;
      }

      final file = files[0];

      // FileReader로 파일 읽기
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      await reader.onLoadEnd.first;

      if (reader.result == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지 데이터를 읽을 수 없습니다')),
          );
        }
        return;
      }

      final bytes = reader.result as Uint8List;

      setState(() {
        _selectedImageBytes = bytes;
        _selectedFileName = file.name;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 선택 실패: $e')),
        );
      }
    }
  }

  Future<void> _saveRecipe(BuildContext context) async {
    try {
      // 1. 이미지 업로드 (선택된 경우)
      if (_selectedImageBytes != null) {
        setState(() {
          _isUploadingImage = true;
        });

        try {
          final fileName = _selectedFileName ??
              'drink_${DateTime.now().millisecondsSinceEpoch}.jpg';

          await _imageUploadService.uploadImageForDrink(
            widget.drink.idx,
            _selectedImageBytes!,
            fileName,
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('이미지 업로드 실패: $e')),
            );
          }
        } finally {
          if (mounted) {
            setState(() {
              _isUploadingImage = false;
            });
          }
        }
      }

      // 2. 레시피 항목 업데이트
      for (var item in _items) {
        await _recipeService.updateRecipe(
          item.idx,
          item.baseIdx,
          item.volume,
        );
      }

      // 3. 칵테일 목록 새로고침
      ref.invalidate(drinkListProvider);

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장되었습니다')),
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
