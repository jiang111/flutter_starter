import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/components/riverpod/base_list_widget.dart';

import '../base/components/riverpod/base_list_notify.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("list"),
      ),
      body: BaseList<String>(
        builder: (context, data, _) => ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text(item),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 1,
          ),
        ),
        provider: listProvider,
      ),
    );
  }
}

final listProvider = AsyncNotifierProvider.autoDispose.family<ListNotify, List<String>, BaseListBean>(
  () => ListNotify(),
  name: 'listProvider',
);

class ListNotify extends BaseListNotify<String> {
  @override
  Future<List<String>> fetchPage(int page) async {
    return Future.delayed(const Duration(seconds: 1), () {
      return List.generate(pageSize, (index) => "$index");
    });
  }
}
