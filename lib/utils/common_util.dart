import 'package:flutter/cupertino.dart';

import '../utils/extension_string.dart';
import '../base/http.dart';

typedef CommitFunction<T> = Future<T> Function();
typedef SuccessFunction<T> = Future<void> Function(T t);
typedef FailFunction = Future<void> Function(Exception t);

Future<void> commit<T>(
  CommitFunction<T> commit, {
  SuccessFunction<T>? success,
  FailFunction? failed,
}) async {
  try {
    "提交中...".loading();
    var result = await commit();

    ///当返回 result 了，就代表肯定是成功了，失败全部走 Exception
    if (success != null) {
      await success(result);
    }

    ///在调用接口时，所有的 Exception 都会被处理成ApiException
  } on ApiException catch (e) {
    eDismiss();
    if (failed != null) {
      await failed(e);
    } else {
      e.message.fail();
    }
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
