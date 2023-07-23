import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_starter/utils/sp_utils.dart';

import 'base/http.dart';

class Initial {
  static Alice alice = Alice(
    showNotification: true,
    showInspectorOnShake: true,
    showShareButton: true,
  );

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
    Http.init();
  }
}
