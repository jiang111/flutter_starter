import 'dart:math';

import '../base.dart';
import 'fimpl/animation_dialog.dart';

final F = _FImpl();

class _FImpl {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  get context => _navigatorKey.currentContext;

  get navigatorKey => _navigatorKey;

  static final _FImpl _singleton = _FImpl._internal();

  ///常用工具方法
  get width => MediaQuery.sizeOf(context).width;

  get height => MediaQuery.sizeOf(context).height;

  String formatTime(int ms) {
    return DateUtil.formatDateMs(ms, format: "yyyy-MM-dd HH:mm:ss");
  }

  bool isLogin() {
    return UserInfo.instance().isLogin();
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void popAllAndPushNewPage(String page) {
    while (context.canPop()) {
      context.pop();
    }
    context.pushReplacement(page);
  }

  /// 常用工具方法 结束

  factory _FImpl() {
    return _singleton;
  }

  _FImpl._internal();

  Future<T?> animatedDialog<T>(
    Widget widget, {
    bool barrierDismissible = true,
    Color? barrierColor,
    bool useSafeArea = true,
    GlobalKey<NavigatorState>? navigatorKey,
    Object? arguments,
    Duration? transitionDuration,
    Curve? transitionCurve,
    String? name,
    RouteSettings? routeSettings,
    EDialogTransition transition = EDialogTransition.scale,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context));

    final theme = Theme.of(context);

    return generalDialog<T>(
      pageBuilder: (buildContext, animation, secondaryAnimation) {
        final pageChild = widget;
        Widget dialog = Builder(builder: (context) {
          return Theme(data: theme, child: pageChild);
        });
        if (useSafeArea) {
          dialog = SafeArea(child: dialog);
        }
        return dialog;
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black45,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = transitionCurve ?? Curves.easeOutQuad;
        switch (transition) {
          case EDialogTransition.fadeScale:
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: curve),
                child: child,
              ),
            );

          case EDialogTransition.rotation3d:
            return Rotation3DTransition(
                Tween<double>(begin: pi, end: 2.0 * pi).animate(CurvedAnimation(parent: animation, curve: curve)),
                child: child);

          default:
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            );
        }
      },
      navigatorKey: navigatorKey,
      routeSettings: routeSettings ?? RouteSettings(arguments: arguments, name: name),
      context: context,
    );
  }
}
