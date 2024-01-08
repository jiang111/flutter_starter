import 'package:alice/alice.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'base.dart';

class Initial {
  static String baseUrl = "";
  static Alice alice = Alice(
    showNotification: isDebug,
    showInspectorOnShake: isDebug,
    showShareButton: isDebug,
  );

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    Http.init(baseUrl: baseUrl);
    GoRouter.optionURLReflectsImperativeAPIs = true;
    //全局竖屏处理
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  static void setAliceNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    if (kIsWeb) {
      return;
    }
    alice.setNavigatorKey(navigatorKey);
  }
}
