import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

///easyLoading 和 flutter_toast 扩展
extension ExtensionString on String? {
  void eLoading() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    if (this != null) {
      EasyLoading.show(status: this!);
    }
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
}

Future<void> eDismiss() {
  return EasyLoading.dismiss();
}
