import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/utils/extension_widget.dart';
import '../base/theme.dart';

import '../base/http.dart';
import '../base/router.dart';
import '../initial.dart';
import '../utils/util.dart';

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
                  "请稍等...".loading();
                  Future.delayed(const Duration(seconds: 3), () {
                    "提交成功".success();
                  });
                }),
            CupertinoButton(
                child: const Text("列表分页加载"),
                onPressed: () {
                  appRouter.push(RoutePaths.list);
                }),
            "切换黑色主题"
                .toText(
              color: BaseTheme.of(ref).xff00ff(),
            )
                .click(() {
              ref.watch(themeProvider.notifier).change(1);
            }).padding(15.paddingAll()),
            "切换Material3主题"
                .toText(
              style: BaseTheme.of(ref).xff00ff().textStyle(),
            )
                .click(
              () {
                ref.watch(themeProvider.notifier).change(2);
              },
            ).container(
              padding: 15.paddingAll(),
            ),
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
                child: const Text(
                  "网络请求日志",
                ),
                onPressed: () {
                  Initial.alice.showInspector();
                }),
            CupertinoButton(
              child: const Text("网络请求"),
              onPressed: () async {
                commit<String?>(
                  () async {
                    return Http().get<String>("https://newtab.work", isolate: true);
                  },
                  success: (t) async {
                    t?.toast();
                    t?.i();
                  },
                );
              },
            ),
            "选择时间"
                .toText(
              style: BaseTheme.of(ref).xff00ff().textStyle(),
            )
                .click(
              () async {
                var result = await DatePickerBdaya.showDatePicker(context, locale: LocaleType.zh);
                result?.toIso8601String().toast();
              },
            ).container(
              padding: 15.paddingAll(),
            ),
          ],
        ),
      ),
    );
  }
}
