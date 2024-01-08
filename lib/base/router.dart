import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/base/user_info.dart';
import 'package:flutter_starter/test/splash.dart';
import '../test/home_page.dart';
import '../test/list_page.dart';
import '../test/login_page.dart';
import 'package:go_router/go_router.dart';

import '../utils/f.dart';

class RoutePaths {
  static List<String> ignoreInterceptor = [main, home];

  static String main = '/';

  // 首页
  static String home = '/home';
  static String login = '/login';
  static String list = '/list';
}

final appRouter = GoRouter(
  debugLogDiagnostics: !kReleaseMode,
  navigatorKey: F.navigatorKey,
  initialLocation: RoutePaths.main,
  redirect: (context, state) => loginInterceptor(context, state),
  routes: [
    GoRoute(
      path: RoutePaths.main,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RoutePaths.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RoutePaths.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RoutePaths.list,
      builder: (context, state) => const ListPage(),
    ),
  ],
);

FutureOr<String?> loginInterceptor(BuildContext context, GoRouterState state) async {
  for (var element in RoutePaths.ignoreInterceptor) {
    if (element == state.matchedLocation) {
      return null;
    }
  }

  if (F.isLogin()) {
    return null;
  }

  return RoutePaths.login;
}
