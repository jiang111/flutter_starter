import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/utils/sp_utils.dart';

final themeProvider = StateNotifierProvider<ThemeViewModel, BaseTheme>((ref) {
  var lightTheme = SpUtil.getBool("lightTheme", defValue: true);

  BaseTheme theme;
  if (lightTheme) {
    theme = LightTheme();
  } else {
    theme = DarkTheme();
  }
  return ThemeViewModel(theme);
});

class ThemeViewModel extends StateNotifier<BaseTheme> {
  ThemeViewModel(super.state);

  void change() {
    if (state is LightTheme) {
      state = DarkTheme();
    } else {
      state = LightTheme();
    }
    SpUtil.putBool("lightTheme", state is LightTheme);
  }
}

abstract class BaseTheme {
  ThemeData themeData();
}

class LightTheme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.light();
  }
}

class DarkTheme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.dark();
  }
}
