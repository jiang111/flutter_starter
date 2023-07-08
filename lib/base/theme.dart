import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/utils/sp_utils.dart';

final themeProvider = StateNotifierProvider<ThemeViewModel, BaseTheme>((ref) {
  return ThemeViewModel(LightTheme());
});

BaseTheme _getThemeByType(int themeType) {
  switch (themeType) {
    case 0:
      return LightTheme();
    case 1:
      return DarkTheme();
    case 2:
      return Material3Theme();
    default:
      return LightTheme();
  }
}

class ThemeViewModel extends StateNotifier<BaseTheme> {
  ThemeViewModel(super.state);

  void change(int type) {
    state = _getThemeByType(type);
    SpUtil.putInt(
      "lightTheme",
      type,
    );
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

class Material3Theme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.light().copyWith(useMaterial3: true);
  }
}
