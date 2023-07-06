import 'package:flutter/cupertino.dart';
import 'package:flutter_starter/utils/sp_utils.dart';



class Initial {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SpUtil.getInstance();
  }
}
