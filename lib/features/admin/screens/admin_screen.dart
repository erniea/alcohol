import 'package:alcohol/features/admin/widgets/base_management.dart';
import 'package:alcohol/features/admin/widgets/drink_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? '재료 관리' : '칵테일 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: '메인으로',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          BaseManagement(),
          DrinkManagement(),
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
            icon: Icon(Icons.liquor_outlined),
            selectedIcon: Icon(Icons.liquor),
            label: '재료',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_bar_outlined),
            selectedIcon: Icon(Icons.local_bar),
            label: '칵테일',
          ),
        ],
      ),
    );
  }
}
