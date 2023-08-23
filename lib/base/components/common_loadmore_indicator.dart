import 'package:flutter/foundation.dart';

import '../../base.dart';

class CommonLoadMoreController {
  bool canLoadMore = true;

  void disableLoadMore() {
    canLoadMore = false;
  }

  void enableLoadMore() {
    canLoadMore = true;
  }
}

class CommonLoadMoreIndicator extends StatefulWidget {
  final bool canLoadMore;
  final Widget child;
  final AsyncCallback onLoadMore;
  final CommonLoadMoreController? controller;

  const CommonLoadMoreIndicator({
    super.key,
    required this.canLoadMore,
    required this.child,
    required this.onLoadMore,
    this.controller,
  });

  @override
  State<CommonLoadMoreIndicator> createState() => _CommonLoadMoreIndicatorState();
}

class _CommonLoadMoreIndicatorState extends State<CommonLoadMoreIndicator> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!widget.canLoadMore) {
            return false;
          }
          if (!(widget.controller?.canLoadMore ?? true)) {
            return false;
          }
          if (isLoading) {
            return false;
          }

          if (notification is ScrollUpdateNotification) {
            if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
              isLoading = true;
              widget.onLoadMore().then((value) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  isLoading = false;
                });
              }).catchError((_) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  isLoading = false;
                });
              });
            }
          }
          return false;
        },
        child: widget.child);
  }
}
