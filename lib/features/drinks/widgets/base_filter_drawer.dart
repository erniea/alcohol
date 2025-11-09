import 'package:alcohol/models/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alcohol/features/drinks/providers/base_providers.dart';
import 'package:alcohol/features/drinks/providers/drink_providers.dart';

class BaseFilterDrawer extends ConsumerWidget {
  const BaseFilterDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basesAsync = ref.watch(baseListProvider);
    final baseFilter = ref.watch(baseFilterProvider);

    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: basesAsync.when(
          data: (bases) {
            List<Widget> widgets = <Widget>[];

            for (var base in bases) {
              if (base.inStock) {
                widgets.add(
                  SwitchListTile(
                    title: Text(base.name),
                    value: baseFilter.contains(base.idx),
                    onChanged: (bool value) {
                      ref.read(baseFilterProvider.notifier).toggle(base.idx);
                    },
                  ),
                );
              }
            }

            return ListView(children: widgets);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
