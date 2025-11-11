import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/admin/widgets/recipe_edit_dialog.dart';
import 'package:alcohol/services/image_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class DrinkManagement extends ConsumerWidget {
  const DrinkManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drinksAsync = ref.watch(drinkListProvider);

    return Scaffold(
      body: drinksAsync.when(
        data: (drinks) {
          if (drinks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_bar_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 칵테일이 없습니다',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아래 + 버튼을 눌러 칵테일을 추가하세요',
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
              ref.invalidate(drinkListProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: drinks.length,
              itemBuilder: (context, index) {
                final drink = drinks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => RecipeEditDialog(drink: drink),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: drink.recipe.available
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.errorContainer,
                            child: Icon(
                              Icons.local_bar,
                              color: drink.recipe.available
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  drink.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                if (drink.desc.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    drink.desc,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.restaurant_menu,
                                      size: 14,
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '재료 ${drink.recipe.elements.length}개',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ],
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
                  ref.invalidate(drinkListProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'drink_fab',
        onPressed: () {
          _showAddDrinkDialog(context, ref);
        },
        icon: const Icon(Icons.add),
        label: const Text('칵테일 추가'),
      ),
    );
  }

  void _showAddDrinkDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AddDrinkDialog(ref: ref),
    );
  }
}

class _AddDrinkDialog extends StatefulWidget {
  final WidgetRef ref;

  const _AddDrinkDialog({required this.ref});

  @override
  State<_AddDrinkDialog> createState() => _AddDrinkDialogState();
}

class _AddDrinkDialogState extends State<_AddDrinkDialog> {
  final nameController = TextEditingController();
  final imgController = TextEditingController();
  final descController = TextEditingController();
  final _imageUploadService = ImageUploadService();

  Uint8List? _selectedImageBytes;
  String? _selectedFileName;
  bool _isUploading = false;

  @override
  void dispose() {
    nameController.dispose();
    imgController.dispose();
    descController.dispose();
    super.dispose();
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

  Future<String?> _uploadImageForDrink(int drinkIdx) async {
    if (_selectedImageBytes == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      // 파일명이 있으면 사용, 없으면 타임스탬프 사용
      final fileName = _selectedFileName ??
          'drink_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final imageUrl = await _imageUploadService.uploadImageForDrink(
        drinkIdx,
        _selectedImageBytes!,
        fileName,
      );
      return imageUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드 실패: $e')),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('새 칵테일 추가'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '칵테일 이름',
                hintText: '예: 모히또, 마가리타 등',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 이미지 선택 영역
            if (_selectedImageBytes != null)
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
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
                        });
                      },
                    ),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('이미지 선택'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

            const SizedBox(height: 12),
            const Text(
              '또는',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: imgController,
              decoration: const InputDecoration(
                labelText: '이미지 URL (선택)',
                hintText: 'https://...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '설명 (선택)',
                hintText: '칵테일에 대한 설명',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isUploading
              ? null
              : () async {
                  if (nameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('칵테일 이름을 입력하세요')),
                    );
                    return;
                  }

                  try {
                    // 1. 먼저 칵테일을 생성 (이미지 URL이 있으면 사용)
                    final newDrink =
                        await widget.ref.read(drinkListProvider.notifier).addDrink(
                              nameController.text,
                              imgController.text,
                              descController.text,
                            );

                    // 2. 이미지가 선택되었으면 업로드
                    if (_selectedImageBytes != null && newDrink != null) {
                      final uploadedUrl = await _uploadImageForDrink(newDrink.idx);

                      if (uploadedUrl == null) {
                        // 업로드 실패했지만 칵테일은 이미 생성됨
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('이미지 업로드 실패. 나중에 수정해주세요.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }

                      // 3. 목록 새로고침 (이미지 업로드 후 업데이트된 데이터 가져오기)
                      widget.ref.invalidate(drinkListProvider);
                    }

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
                },
          child: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('추가'),
        ),
      ],
    );
  }
}
