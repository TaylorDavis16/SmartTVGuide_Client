import 'package:flutter/material.dart';
import 'package:smart_tv_guide/http/core/hi_state.dart';

import '../../util/color.dart';
import '../../util/toast.dart';
import 'hi_error.dart';

///通用底层带分页和刷新的页面框架
///M为Dao返回数据模型，L为列表数据模型，T为具体widget
abstract class BaseState<T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  int pageIndex;
  bool loading = false;
  bool removeTop;
  bool needScrollController;
  ScrollController? scrollController;

  BaseState({
    this.pageIndex = 0,
    this.removeTop = false,
    this.needScrollController = false,
    this.scrollController,
  });

  get contentChild;

  @override
  void initState() {
    super.initState();
    print('initiating!!!!!!!!!!!!!');
    if (needScrollController) {
      scrollController = ScrollController();
      scrollController!.addListener(() {
        var dis = scrollController!.position.maxScrollExtent -
            scrollController!.position.pixels;
        // print('$dis');
        //当距离底部不足300时加载更多
        if (dis < 100 && !loading
            //fix 当列表高度不满屏幕高度时不执行加载更多
            // && scrollController.position.maxScrollExtent != 0
            ) {
          print('------_loadData---');
          loadData(loadMore: true);
        }
      });
    }
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: loadData,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: removeTop, context: context, child: contentChild),
    );
  }

  Future<void> customLoad({loadMore = false}) async{}

  Future<void> loadData({loadMore = false}) async {
    if (!loading) {
      loading = true;
      if (!loadMore) {
        pageIndex = 0;
      }
      try {
        print('pageIndex: $pageIndex');
        await customLoad(loadMore: loadMore);
        // Future.delayed(const Duration(milliseconds: 1000), () {
        //   loading = false;
        // });
      } on NeedAuth catch (e) {
        showWarnToast(e.message);
      } on HiNetError catch (e) {
        showWarnToast(e.message);
      } finally {
        loading = false;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
