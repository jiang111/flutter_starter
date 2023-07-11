import 'package:flutter_starter/base/http.dart';
import 'package:flutter_starter/utils/extension_string.dart';

typedef CommitFunction<T> = Future<T> Function();
typedef CompleteFunction<T> = void Function(T t);

Future<void> commit<T>(
  CommitFunction<T> commit, {
  String? success,
  CompleteFunction<T>? after,
}) async {
  try {
    "提交中...".eLoading();
    var result = await commit();
    success.eSuccess();
    if (after != null) {
      after(result);
    }
  } on ApiException catch (e) {
    eDismiss();
    e.message.eFail();
  }
}
