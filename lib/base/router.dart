import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../test/home_page.dart';
import '../test/list_page.dart';
import '../test/login_page.dart';
import 'package:go_router/go_router.dart';

import '../initial.dart';

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
  navigatorKey: Initial.alice.getNavigatorKey(),
  initialLocation: RoutePaths.main,
  redirect: (context, state) => loginInterceptor(context, state),
  routes: [
    GoRoute(
      path: RoutePaths.main,
      builder: (context, state) => const HomePage(),
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

FutureOr<String?> loginInterceptor(BuildContext context, GoRouterState state) {
  for (var element in RoutePaths.ignoreInterceptor) {
    if (element == state.matchedLocation) {
      return null;
    }
  }

  if (isLogin()) {
    return null;
  }

  return RoutePaths.login;
}

bool isLogin() {
  return Random().nextBool();
}
