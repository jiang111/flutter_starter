import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? confirmText;
  final VoidCallback confirmCallback;
  final bool hideCancelBtn;
  final bool autoPop;

  const CommonDialog({
    super.key,
    this.title,
    required this.autoPop,
    this.content,
    required this.hideCancelBtn,
    this.confirmText,
    required this.confirmCallback,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title == null ? null : Text(title!),
      content: content == null ? null : Text(content!),
      actions: hideCancelBtn
          ? [
              CupertinoDialogAction(
                isDestructiveAction: false,
                onPressed: () {
                  if (autoPop) {
                    Navigator.of(context).pop();
                  }
                  confirmCallback();
                },
                child: Text(
                  confirmText ?? "确定",
                  style: const TextStyle(
                    color: Color(0xFFFF9E34),
                  ),
                ),
              ),
            ]
          : [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "取消",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmCallback();
                },
                child: Text(
                  confirmText ?? "确定",
                  style: const TextStyle(
                    color: Color(0xFFFF9E34),
                  ),
                ),
              ),
            ],
    );
  }
}

Future<T?> showCommonDialog<T>(
  BuildContext context, {
  String? title,
  bool autoPop = true,
  String? content,
  bool barrierDismissible = true,
  bool hideCancelBtn = false,
  String? confirmText,
  required VoidCallback confirmCallback,
}) {
  return showCupertinoDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      return CommonDialog(
        title: title,
        content: content,
        autoPop: autoPop,
        confirmText: confirmText,
        hideCancelBtn: hideCancelBtn,
        confirmCallback: confirmCallback,
      );
    },
  );
}
