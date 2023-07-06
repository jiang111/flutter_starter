import 'package:flutter_starter/test/home_page.dart';
import 'package:flutter_starter/test/list_page.dart';
import 'package:go_router/go_router.dart';

class RoutePaths {
  static String main = '/';

  // 首页
  static String home = '/home';
  static String list = '/list';
}

final appRouter = GoRouter(
  initialLocation: RoutePaths.main,
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
      path: RoutePaths.list,
      builder: (context, state) => const ListPage(),
    ),
  ],
);
