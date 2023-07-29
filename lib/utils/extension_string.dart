import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_starter/utils/extension_widget.dart';
import 'package:flutter_starter/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

///easyLoading 和 flutter_toast 扩展
extension ExtensionString on String? {
  bool isEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotEmpty() {
    return !isEmpty();
  }

  void eLoading() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    if (this != null) {
      EasyLoading.show(
        status: this!,
        maskType: EasyLoadingMaskType.clear,
      );
    }
  }

  Widget toText({TextStyle? style, double? size, Color? color}) {
    return Text(
      this ?? "",
      style: style ??
          TextStyle(
            color: color,
            fontSize: size,
          ),
    );
  }

  void eFail() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    if (this != null) {
      EasyLoading.showError(this!);
    }
  }

  void eSuccess() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    if (this != null) {
      EasyLoading.showSuccess(this!);
    }
  }

  void toast() {
    if (this == null) return;
    Fluttertoast.showToast(msg: this!);
  }

  void save2SP(String key) {
    if (this == null) return;
    SpUtil.putString(key, this!);
  }

  void toClipboard() {
    if (this == null) return;
    Clipboard.setData(ClipboardData(text: this!));
    "已复制".toast();
  }

  Widget action(VoidCallback onPressed, {TextStyle? style}) {
    return (this ?? "").toText(style: style).padding(15.paddingHorizontal()).click(onPressed);
  }
}

extension ExtensionIconData on IconData {
  Widget action(VoidCallback onPressed, {Color? color, double? size}) {
    return Icon(this, color: color, size: size).padding(15.paddingHorizontal()).click(onPressed);
  }
}

Future<void> eDismiss() {
  return EasyLoading.dismiss();
}
