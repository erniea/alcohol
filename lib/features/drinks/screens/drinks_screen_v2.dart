import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/widgets/drink_card.dart';
import 'package:alcohol/features/drinks/widgets/filter_drawer.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 필터가 변경되면 첫 페이지로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen(filteredDrinksProvider, (previous, next) {
        next.whenData((drinks) {
          if (drinks.isNotEmpty && _pageController.hasClients) {
            _pageController.jumpToPage(0);
            ref.read(currentDrinkIndexProvider.notifier).update(0);
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDrinksAsync = ref.watch(filteredDrinksProvider);
    final currentDrinkAsync = ref.watch(currentDrinkProvider);
    final baseFilter = ref.watch(baseFilterProvider);
    final textFilter = ref.watch(textFilterProvider);

    return Scaffold(
      endDrawer: const FilterDrawer(),
      appBar: AppBar(
        title: _currentIndex == 0
            ? const Text('칵테일')
            : const Text('평가'),
        actions: [
          if (_currentIndex == 0) ...[
            // 필터 초기화 버튼
            if (baseFilter.isNotEmpty || textFilter.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_all),
                tooltip: '필터 초기화',
                onPressed: () {
                  ref.read(baseFilterProvider.notifier).clear();
                  ref.read(textFilterProvider.notifier).clear();
                },
              ),
            // 새로고침 버튼
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '새로고침',
              onPressed: () {
                ref.invalidate(drinkListProvider);
                ref.invalidate(baseListProvider);
              },
            ),
          ],
          // 관리자 모드 버튼
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
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
            selectedIcon: Icon(Icons.local_bar),
            label: '칵테일',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '평가',
          ),
        ],
      ),
    );
  }

  Widget _buildDrinksTab(AsyncValue<List> filteredDrinksAsync) {
    final basesAsync = ref.watch(inStockBasesProvider);
    final baseFilter = ref.watch(baseFilterProvider);

    return Column(
      children: [
        // 검색 바
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SearchBar(
            hintText: '칵테일 이름 검색...',
            leading: const Icon(Icons.search),
            onChanged: (value) {
              ref.read(textFilterProvider.notifier).update(value);
            },
            trailing: [
              // 필터 버튼 (Drawer 열기)
              Builder(
                builder: (context) => IconButton(
                  icon: Badge(
                    isLabelVisible: baseFilter.isNotEmpty,
                    label: Text('${baseFilter.length}'),
                    child: const Icon(Icons.filter_list),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),

        // 선택된 필터 Chips
        if (baseFilter.isNotEmpty)
          basesAsync.when(
            data: (bases) {
              final selectedBases =
                  bases.where((b) => baseFilter.contains(b.idx)).toList();

              return Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedBases.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final base = selectedBases[index];
                    return FilterChip(
                      label: Text(base.name),
                      selected: true,
                      onSelected: (_) {
                        ref
                            .read(baseFilterProvider.notifier)
                            .toggle(base.idx);
                      },
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        ref
                            .read(baseFilterProvider.notifier)
                            .toggle(base.idx);
                      },
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
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
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '조건에 맞는 칵테일이 없습니다',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              return PageView.builder(
                controller: _pageController,
                onPageChanged: (int index) {
                  ref.read(currentDrinkIndexProvider.notifier).update(index);
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
                  Icons.chat_bubble_outline,
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
