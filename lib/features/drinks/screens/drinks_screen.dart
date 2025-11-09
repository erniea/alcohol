import 'package:alcohol/features/drinks/providers/drink_providers.dart';
import 'package:alcohol/features/drinks/widgets/base_filter_drawer.dart';
import 'package:alcohol/features/drinks/widgets/drink_card.dart';
import 'package:alcohol/features/social/social_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrinksScreen extends ConsumerStatefulWidget {
  const DrinksScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends ConsumerState<DrinksScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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

    return Scaffold(
      drawer: const BaseFilterDrawer(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(30),
          child: PageView(
            controller: PageController(initialPage: 0),
            scrollDirection: Axis.horizontal,
            onPageChanged: (int inPage) {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            children: <Widget>[
              // 칵테일 목록 페이지
              Column(
                children: [
                  // 검색 필드
                  TextField(
                    onChanged: (value) {
                      ref.read(textFilterProvider.notifier).update(value);
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: '칵테일 이름 검색',
                    ),
                  ),
                  // 칵테일 목록
                  Expanded(
                    child: filteredDrinksAsync.when(
                      data: (drinks) {
                        if (drinks.isEmpty) {
                          return const Center(
                            child: Text('조건에 맞는 칵테일이 없습니다'),
                          );
                        }

                        return PageView.builder(
                          onPageChanged: (int index) {
                            ref
                                .read(currentDrinkIndexProvider.notifier)
                                .update(index);
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: drinks.length,
                          itemBuilder: (context, index) {
                            return DrinkCard(drink: drinks[index]);
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
                            ElevatedButton(
                              onPressed: () {
                                ref.invalidate(drinkListProvider);
                              },
                              child: const Text('다시 시도'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 소셜 페이지
              currentDrinkAsync.when(
                data: (drink) {
                  if (drink == null) {
                    return const Center(
                      child: Text('칵테일을 선택해주세요'),
                    );
                  }
                  return SocialPage(drink: drink);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('오류: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
