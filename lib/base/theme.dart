import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/sp_utils.dart';

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

  Color xff00ff();

  static BaseTheme of(WidgetRef ref) {
    return ref.watch(themeProvider);
  }
}

class LightTheme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.light();
  }

  @override
  Color xff00ff() {
    return const Color(0xffff00ff);
  }
}

class DarkTheme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.dark();
  }

  @override
  Color xff00ff() {
    return const Color(0xff00ff00);
  }
}

class Material3Theme extends BaseTheme {
  @override
  ThemeData themeData() {
    return ThemeData.light().copyWith(useMaterial3: true);
  }

  @override
  Color xff00ff() {
    return const Color(0xff00ffff);
  }
}
