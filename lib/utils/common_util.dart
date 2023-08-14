import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

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
    if (success != null) {
      await success(result);
    }
  } on ApiException catch (e) {
    eDismiss();
    if (failed != null) {
      await failed(e);
    } else {
      e.message.fail();
    }
  } on Exception catch (e) {
    eDismiss();
    if (failed != null) {
      await failed(e);
    } else {
      e.toString().fail();
    }
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void popAllPageAndPushNewPage(BuildContext context, String page) {
  while (context.canPop()) {
    context.pop();
  }
  context.pushReplacement("/login");
}
