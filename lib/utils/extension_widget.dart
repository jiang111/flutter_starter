import 'package:flutter/cupertino.dart';

extension ExtensionWidget on Widget {
  Widget gesture({VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }

  Widget click(VoidCallback onPressed) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 1,
      child: this,
    );
  }

  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  Widget visible(bool visible) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  Widget expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Widget flexible({int flex = 1}) {
    return Flexible(
      fit: FlexFit.loose,
      flex: flex,
      child: this,
    );
  }

  Widget container({
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      alignment: alignment,
      child: this,
    );
  }
}
