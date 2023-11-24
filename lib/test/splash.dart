import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/base/router.dart';

import '../base/components/defer_init.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      appRouter.pushReplacement("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DeferInit(
        create: () async {
          //初始化服务
          return const Center(
            child: Text(
              "Splash Page",
              style: TextStyle(
                color: Color(0xFF3B3552),
                fontSize: 14,
              ),
            ),
          );
        },
        emptyWidget: const Center(
          child: Text(
            'No Data',
          ),
        ),
      ),
    );
  }
}
