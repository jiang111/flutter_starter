import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/test/list_page.dart';
import 'package:flutter_starter/utils/extension_easy_loading.dart';
import 'package:go_router/go_router.dart';

import '../base/router.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoButton(
                child: const Text("show loading dialog"),
                onPressed: () {
                  "请稍等...".eLoading();
                  Future.delayed(const Duration(seconds: 3), () {
                    "提交成功".eSuccess();
                  });
                }),
            CupertinoButton(
                child: const Text("go to list"),
                onPressed: () {
                  context.push(RoutePaths.list);
                }),
          ],
        ),
      ),
    );
  }
}
