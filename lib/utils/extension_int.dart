import 'package:flutter/cupertino.dart';

extension ExtensionInt on int {
  SizedBox width() {
    return SizedBox(width: toDouble());
  }

  SizedBox height() {
    return SizedBox(height: toDouble());
  }

  EdgeInsets paddingAll() {
    return EdgeInsets.all(toDouble());
  }

  EdgeInsets paddingHorizontal({int vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: toDouble(), vertical: vertical.toDouble());
  }

  EdgeInsets paddingVertical({int horizontal = 0}) {
    return EdgeInsets.symmetric(vertical: toDouble(), horizontal: horizontal.toDouble());
  }
}