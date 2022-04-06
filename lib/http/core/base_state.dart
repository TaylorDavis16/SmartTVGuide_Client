import 'package:flutter/material.dart';
import 'package:smart_tv_guide/http/core/my_state.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import '../../util/color.dart';
import '../../util/view_util.dart';
import 'request_error.dart';

///通用底层带分页和刷新的页面框架
///T为具体widget
abstract class BaseState<T extends StatefulWidget> extends MyState<T>
    with AutomaticKeepAliveClientMixin {
  int pageIndex;
  bool loading = false;
  bool removeTop;
  bool needScrollController;
  bool stopLoading = false;
  ScrollController? scrollController;

  BaseState({
    this.pageIndex = 0,
    this.removeTop = false,
    this.needScrollController = false,
    this.scrollController,
  });

  get contentChild;


  void addScrollListener(){
    scrollController!.addListener(() {
      var dis = scrollController!.position.extentAfter;
      // print('$dis');
      //当距离底部不足300时加载更多
      if (dis < 100 &&
          !loading &&
          !stopLoading
          //fix 当列表高度不满屏幕高度时不执行加载更多
          &&
          scrollController!.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
      if (scrollController!.position.extentAfter == 0) {
        bottomMessage(context, stopLoading ? 'You have reached the end' : 'More content is coming......');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    logger.i('initiating!!!!!!!!!!!!!');
    if (needScrollController) {
      scrollController = ScrollController();
      addScrollListener();
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
      onRefresh: refresh,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: removeTop, context: context, child: contentChild),
    );
  }

  Future<void> refresh() async {
    stopLoading = false;
    await loadData();
  }

  Future<void> customLoad({loadMore = false}) async {}

  Future<void> loadData({loadMore = false}) async {
    if (!loading) {
      loading = true;
      if (!loadMore) {
        pageIndex = 0;
      }
      try {
        await customLoad(loadMore: loadMore);
        logger.i('------_loadData---, pageIndex: $pageIndex');
        if (stopLoading) {
          bottomMessage(context, 'You have reached the end');
        }
      } on NeedAuth catch (e) {
        logger.e(e.message);
        showWarnToast('NO Authentication');
      } on RequestError catch (e) {
        logger.e(e.message);
        showWarnToast('Network Error 1');
      } catch (e) {
        logger.e(e.toString());
        showWarnToast('Network Error 2');
      } finally {
        loading = false;
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}
