import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/base/theme.dart';
import 'package:flutter_starter/utils/extension_easy_loading.dart';
import 'package:flutter_starter/utils/extension_log.dart';

import '../base/http.dart';
import '../base/router.dart';
import '../utils/utils.dart';

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
                child: const Text("显示loading样式"),
                onPressed: () {
                  "请稍等...".eLoading();
                  Future.delayed(const Duration(seconds: 3), () {
                    "提交成功".eSuccess();
                  });
                }),
            CupertinoButton(
                child: const Text("列表分页加载"),
                onPressed: () {
                  appRouter.push(RoutePaths.list);
                }),
            CupertinoButton(
                child: Text(
                  "切换黑色主题",
                  style: TextStyle(
                    color: BaseTheme.of(ref).xff00ff(),
                  ),
                ),
                onPressed: () {
                  ref.watch(themeProvider.notifier).change(1);
                }),
            CupertinoButton(
                child: Text(
                  "切换Material3主题",
                  style: TextStyle(
                    color: BaseTheme.of(ref).xff00ff(),
                  ),
                ),
                onPressed: () {
                  ref.watch(themeProvider.notifier).change(2);
                }),
            CupertinoButton(
                child: Text(
                  "重置主题",
                  style: TextStyle(
                    color: BaseTheme.of(ref).xff00ff(),
                  ),
                ),
                onPressed: () {
                  ref.watch(themeProvider.notifier).change(0);
                }),
            CupertinoButton(
                child: const Text("网络请求"),
                onPressed: () async {
                  commit<String?>(
                      () async {
                        return Http().get<String>("https://baidu.com", isolate: true);
                      },
                      success: "提交成功",
                      after: (t) {
                        t.i();
                      });
                }),
          ],
        ),
      ),
    );
  }
}
