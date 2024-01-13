import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../multi_state_widget.dart';
import 'base_list_notify.dart';

typedef RiverpodWidgetBuilder<T> = Widget Function(
    BuildContext context, List<T> data, bool hasMore, BaseListBean baseListBean);

class BaseListBean {
  //加载更多的 controller
  EasyRefreshController? easyRefreshController;

  //需要传递的参数
  dynamic data;
}

class BaseList<T> extends ConsumerStatefulWidget {
  final AutoDisposeAsyncNotifierProviderFamily<BaseListNotify<T>, List<T>, BaseListBean> provider;

  final RiverpodWidgetBuilder<T> builder;
  final bool enablePullDown;
  final bool enablePullUp;
  final dynamic arguments;
  final BaseListBean? baseList;

  const BaseList({
    super.key,
    required this.provider,
    this.arguments,
    required this.builder,
    this.baseList,
    this.enablePullDown = true,
    this.enablePullUp = true,
  });

  @override
  ConsumerState<BaseList<T>> createState() => _BaseListState<T>();
}

class _BaseListState<T> extends ConsumerState<BaseList<T>> {
  late final BaseListBean _baseListBean;

  @override
  void initState() {
    if (widget.baseList == null) {
      _baseListBean = BaseListBean();
      _baseListBean.easyRefreshController = EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      );
      _baseListBean.data = widget.arguments;
    } else {
      _baseListBean = widget.baseList!;
    }

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
          return EasyRefresh(
              controller: _baseListBean.easyRefreshController,
              onRefresh: () async {
                await ref.watch(widget.provider(_baseListBean).notifier).loadData(refresh: true);
                _baseListBean.easyRefreshController?.finishRefresh();
                _baseListBean.easyRefreshController?.resetFooter();
              },
              onLoad: () async {
                await ref.watch(widget.provider(_baseListBean).notifier).loadData(refresh: false);
                bool hasMore = data.length % (ref.watch(widget.provider(_baseListBean).notifier).pageSize) == 0;
                _baseListBean.easyRefreshController
                    ?.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
              },
              child: widget.builder(context, data,
                  data.length % (ref.watch(widget.provider(_baseListBean).notifier).pageSize) == 0, _baseListBean));
        });
  }
}
