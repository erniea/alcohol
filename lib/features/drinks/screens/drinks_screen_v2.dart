import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/widgets/drink_card.dart';
import 'package:alcohol/features/social/social_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinksScreenV2 extends ConsumerStatefulWidget {
  const DrinksScreenV2({Key? key}) : super(key: key);

  @override
  ConsumerState<DrinksScreenV2> createState() => _DrinksScreenV2State();
}

class _DrinksScreenV2State extends ConsumerState<DrinksScreenV2> {
  int _currentIndex = 0;
  late PageController _pageController;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: _FilterBottomSheet(scrollController: scrollController),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredDrinksAsync = ref.watch(filteredDrinksProvider);
    final currentDrinkAsync = ref.watch(currentDrinkProvider);
    final baseFilter = ref.watch(baseFilterProvider);
    final textFilter = ref.watch(textFilterProvider);

    // 필터가 변경되면 첫 페이지로 이동
    ref.listen(filteredDrinksProvider, (previous, next) {
      next.whenData((drinks) {
        if (drinks.isNotEmpty) {
          // 먼저 상태 업데이트
          ref.read(currentDrinkIndexProvider.notifier).update(0);
          ref.read(currentDrinkIdProvider.notifier).update(drinks[0].idx);

          // PageController가 준비되면 페이지 이동
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients && mounted) {
              _pageController.jumpToPage(0);
            }
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0 ? const Text('칵테일') : const Text('평가'),
        actions: [
          if (_currentIndex == 0) ...[
            // 새로고침 버튼
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: '새로고침',
              onPressed: () {
                ref.invalidate(drinkListProvider);
                ref.invalidate(baseListProvider);
              },
            ),
          ],
          // 관리자 모드 버튼
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_rounded),
            tooltip: '관리자 모드',
            onPressed: () {
              Navigator.of(context).pushNamed('/admin');
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDrinksTab(filteredDrinksAsync),
          _buildSocialTab(currentDrinkAsync),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_bar_outlined),
            selectedIcon: Icon(Icons.local_bar_rounded),
            label: '칵테일',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: '평가',
          ),
        ],
      ),
    );
  }

  Widget _buildDrinksTab(AsyncValue<List> filteredDrinksAsync) {
    final basesAsync = ref.watch(inStockBasesProvider);
    final baseFilter = ref.watch(baseFilterProvider);
    final textFilter = ref.watch(textFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final hasActiveFilters = baseFilter.isNotEmpty || textFilter.isNotEmpty;

    return Column(
      children: [
        // 통합 검색 및 필터 영역
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 검색바와 필터 버튼
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (value) {
                          ref.read(textFilterProvider.notifier).update(value);
                        },
                        decoration: InputDecoration(
                          hintText: '칵테일 이름 검색...',
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          suffixIcon: textFilter.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(textFilterProvider.notifier).clear();
                                    _searchFocusNode.unfocus();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 필터 버튼
                  Container(
                    decoration: BoxDecoration(
                      color: baseFilter.isNotEmpty
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: Badge(
                        isLabelVisible: baseFilter.isNotEmpty,
                        label: Text('${baseFilter.length}'),
                        child: Icon(
                          Icons.tune_rounded,
                          color: baseFilter.isNotEmpty
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      tooltip: '필터',
                      onPressed: _showFilterBottomSheet,
                    ),
                  ),
                ],
              ),

              // 활성화된 필터 칩
              if (baseFilter.isNotEmpty) ...[
                const SizedBox(height: 12),
                basesAsync.when(
                  data: (bases) {
                    final selectedBases =
                        bases.where((b) => baseFilter.contains(b.idx)).toList();

                    return SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedBases.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final base = selectedBases[index];
                                return FilterChip(
                                  avatar: Icon(
                                    Icons.liquor_rounded,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                  label: Text(base.name),
                                  selected: true,
                                  onSelected: (_) {
                                    ref
                                        .read(baseFilterProvider.notifier)
                                        .toggle(base.idx);
                                  },
                                  onDeleted: () {
                                    ref
                                        .read(baseFilterProvider.notifier)
                                        .toggle(base.idx);
                                  },
                                  deleteIcon: const Icon(Icons.close_rounded, size: 18),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],

              // 필터 초기화 버튼
              if (hasActiveFilters) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      ref.read(baseFilterProvider.notifier).clear();
                      ref.read(textFilterProvider.notifier).clear();
                      _searchFocusNode.unfocus();
                    },
                    icon: const Icon(Icons.clear_all_rounded, size: 18),
                    label: const Text('모든 필터 초기화'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // 칵테일 목록
        Expanded(
          child: filteredDrinksAsync.when(
            data: (drinks) {
              if (drinks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_bar_outlined,
                        size: 80,
                        color: colorScheme.outline.withOpacity(0.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        hasActiveFilters
                            ? '조건에 맞는 칵테일이 없습니다'
                            : '칵테일이 없습니다',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      if (hasActiveFilters) ...[
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            ref.read(baseFilterProvider.notifier).clear();
                            ref.read(textFilterProvider.notifier).clear();
                          },
                          icon: const Icon(Icons.clear_all_rounded),
                          label: const Text('필터 초기화'),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return PageView.builder(
                controller: _pageController,
                onPageChanged: (int index) {
                  ref.read(currentDrinkIndexProvider.notifier).update(index);
                  ref
                      .read(currentDrinkIdProvider.notifier)
                      .update(drinks[index].idx);
                },
                scrollDirection: Axis.vertical,
                itemCount: drinks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: DrinkCard(drink: drinks[index]),
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
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '오류가 발생했습니다',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(drinkListProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialTab(AsyncValue currentDrinkAsync) {
    return currentDrinkAsync.when(
      data: (drink) {
        if (drink == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  '칵테일을 선택해주세요',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SocialPage(drink: drink),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text('오류: $error'),
      ),
    );
  }
}

// 필터 바텀 시트 위젯
class _FilterBottomSheet extends ConsumerWidget {
  final ScrollController scrollController;

  const _FilterBottomSheet({required this.scrollController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(baseListProvider);
    final baseFilter = ref.watch(baseFilterProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // 핸들
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '재료 필터',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '보유한 재료를 선택하세요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (baseFilter.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    ref.read(baseFilterProvider.notifier).clear();
                  },
                  icon: const Icon(Icons.clear_all_rounded, size: 18),
                  label: const Text('초기화'),
                ),
            ],
          ),
        ),

        const Divider(height: 1),

        // 재료 목록
        Expanded(
          child: basesAsync.when(
            data: (bases) {
              final inStockBases = bases.where((base) => base.inStock).toList();

              if (inStockBases.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '재고가 있는 재료가 없습니다',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: inStockBases.length,
                itemBuilder: (context, index) {
                  final base = inStockBases[index];
                  final isSelected = baseFilter.contains(base.idx);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer.withOpacity(0.5)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        base.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        ref
                            .read(baseFilterProvider.notifier)
                            .toggle(base.idx);
                      },
                      secondary: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.liquor_rounded,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.outline,
                          size: 24,
                        ),
                      ),
                      activeColor: colorScheme.primary,
                      checkColor: colorScheme.onPrimary,
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
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '재료를 불러올 수 없습니다',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(baseListProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 하단 통계
        if (baseFilter.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.onSecondaryContainer,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  '${baseFilter.length}개의 재료 선택됨',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
