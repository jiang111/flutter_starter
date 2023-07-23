import 'dart:math';

class UserInfo {
  //单例
  static UserInfo? _instance;

  static UserInfo instance() {
    _instance ??= UserInfo._();
    return _instance!;
  }

  UserInfo._();

  bool isLogin() {
    return Random().nextBool();
  }
}
