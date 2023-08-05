import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_starter/utils/sp_util.dart';

import 'base/http.dart';

class Initial {
  static String baseUrl = "";
  static Alice alice = Alice(
    showNotification: true,
    showInspectorOnShake: true,
    showShareButton: true,
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
