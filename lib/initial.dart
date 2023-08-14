import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
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
    //全局竖屏处理
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }
}
