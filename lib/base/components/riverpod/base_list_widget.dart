import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../multi_state_widget.dart';
import 'base_list_notify.dart';

typedef WidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> data, BaseListBean baseListBean);

class BaseListBean {
  RefreshController? controller;
  dynamic data;
}

class BaseList<T> extends ConsumerStatefulWidget {
  final AutoDisposeAsyncNotifierProviderFamily<BaseListNotify<T>, List<T>,
      BaseListBean> provider;

  final WidgetBuilder<T> builder;
  final bool enablePullDown;
  final bool enablePullUp;
  final dynamic arguments;

  const BaseList({
    Key? key,
    required this.provider,
    this.arguments,
    required this.builder,
    this.enablePullDown = true,
    this.enablePullUp = true,
  }) : super(key: key);

  @override
  ConsumerState<BaseList<T>> createState() => _BaseListState<T>();
}

class _BaseListState<T> extends ConsumerState<BaseList<T>> {
  final RefreshController refreshController = RefreshController();
  late final BaseListBean _baseListBean;

  @override
  void initState() {
    _baseListBean = BaseListBean();
    _baseListBean.controller = refreshController;
    _baseListBean.data = widget.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //由于需要传入_refreshController,所以每个 provider 都会被重新实例化，同一个 provider 不会被复用
    // 但是由于refreshController是自动生成的，导致控件外无法直接拿到这个provider实例。
    //如果必须在外部拿到这个实例，可以通过findAncestorWidgetOfExactType()方法向上查找。
    // 或者让provider监听一个StateProvider，然后修改StateProvider的值，来达到刷新的操作。
    var result = ref.watch(widget.provider(_baseListBean));

    return MultiStateWidget<List<T>>(
        value: result,
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text("暂无数据"),
            );
          }
          return SmartRefresher(
            enablePullDown: widget.enablePullDown,
            enablePullUp: widget.enablePullUp,
            controller: refreshController,
            onRefresh: () => ref
                .watch(widget.provider(_baseListBean).notifier)
                .loadData(refresh: true),
            onLoading: () => ref
                .watch(widget.provider(_baseListBean).notifier)
                .loadData(refresh: false),
            child: widget.builder(context, data, _baseListBean),
          );
        });
  }
}
