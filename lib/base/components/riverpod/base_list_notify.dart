import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_list_widget.dart';

abstract class BaseListNotify<T> extends AutoDisposeFamilyAsyncNotifier<List<T>, BaseListBean> {
  int page = 1;
  int pageSize = 20;
  bool error = false;
  bool hasNoMore = false;
  EasyRefreshController? easyRefreshController;
  String errorMsg = '';
  dynamic params;
  CancelToken? cancelToken;

  void init() {}

  @override
  FutureOr<List<T>> build(BaseListBean arg) async {
    init();
    ref.onDispose(() {
      dispose();
    });
    easyRefreshController = arg.easyRefreshController;
    params = arg.data;
    await prepare();
    return await _initial();
  }

  @mustCallSuper
  void dispose() {
    cancelToken?.cancel();
  }

  CancelToken randomCancelToken() {
    cancelToken = CancelToken();
    return cancelToken!;
  }

  Future<void> prepare() async {}

  void resetRefreshControllerState({bool refresh = false}) {
    if (hasNoMore) {
      easyRefreshController?.finishLoad(IndicatorResult.noMore);
    } else {
      easyRefreshController?.finishLoad(IndicatorResult.success);
    }
  }

  Future<List<T>?> fetchPage(int page);

  //只有第一次进入页面时调用
  FutureOr<List<T>> _initial() async {
    try {
      page = 1;
      var result = await fetchPage(page) ?? [];
      page++;
      if (result.length < pageSize) {
        hasNoMore = true;
      } else {
        hasNoMore = false;
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        resetRefreshControllerState(refresh: true);
      });
      loadDataCompleted(result);
      return result;
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        resetRefreshControllerState(refresh: true);
      });
      errorMsg = e.toString();
      throw Exception(errorMsg);
    }
  }

  Future<void> loadData({bool refresh = false, bool showLoadingState = false}) async {
    try {
      if (refresh) {
        if (showLoadingState) {
          state = AsyncValue<List<T>>.loading();
        }
        page = 1;
      }

      //重置所有状态
      error = false;
      hasNoMore = false;

      state = await AsyncValue.guard(() async {
        var result = await fetchPage(page);
        page++;
        if ((result?.length ?? 0) < pageSize) {
          hasNoMore = true;
        }
        if (refresh) {
          return result ?? [];
        } else {
          return [...(state.value ?? []), ...(result ?? [])];
        }
      });
      loadDataCompleted(state.value);
    } catch (e) {
      print(e);
      error = true;

      errorMsg = e.toString();
      if (page == 1) {
        state = AsyncValue.error(errorMsg, StackTrace.current);
      }
    }
    resetRefreshControllerState(refresh: refresh);
  }

  void loadDataCompleted(List<T>? result) {}
}
