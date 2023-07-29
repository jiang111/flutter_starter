import 'package:flutter/cupertino.dart';
import 'package:flutter_starter/utils/date_util.dart';

extension ExtensionInt on int? {
  SizedBox width() {
    return SizedBox(width: toInt().toDouble());
  }

  int toInt() {
    return this ?? 0;
  }

  String toYMD() {
    return DateUtil.formatDateMs(toInt(), format: DateFormats.y_mo_d);
  }

  String toYMDHMS() {
    return DateUtil.formatDateMs(toInt(), format: DateFormats.full);
  }

  SizedBox height() {
    return SizedBox(height: toInt().toDouble());
  }

  EdgeInsets paddingAll() {
    return EdgeInsets.all(toInt().toDouble());
  }

  EdgeInsets paddingHorizontal({int vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: toInt().toDouble(), vertical: vertical.toDouble());
  }

  EdgeInsets paddingVertical({int horizontal = 0}) {
    return EdgeInsets.symmetric(vertical: toInt().toDouble(), horizontal: horizontal.toDouble());
  }

  TextStyle textStyle({Color? color}) {
    return TextStyle(fontSize: toInt().toDouble(), color: color);
  }
}

extension ExtensionColor on Color {
  TextStyle textStyle({double? size}) {
    return TextStyle(fontSize: size, color: this);
  }
}
