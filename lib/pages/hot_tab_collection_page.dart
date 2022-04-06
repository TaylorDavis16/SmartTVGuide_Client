import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/navigator/my_navigator.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/util/app_util.dart';

class HotTabCollectionPage extends StatefulWidget {
  const HotTabCollectionPage({Key? key}) : super(key: key);

  @override
  _HotTabCollectionPageState createState() => _HotTabCollectionPageState();
}

class _HotTabCollectionPageState extends HotTabState<HotTabCollectionPage> {
  _HotTabCollectionPageState() : super(needLogin: true);
  List totalPrograms = [];
  late RouteChangeListener listener;
  @override
  void initState() {
    MyNavigator().addListener(listener = (current, pre) {
      if(widget == current.page && pre.page is ProgramDetail){
        setState(() {loadData();});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyNavigator().onTabChange(widget);
    return super.build(context);
  }

  void reset() {
    Map collection = UserDao.getProgramCollection();
    totalPrograms.clear();
    programs.clear();
    for (var list in collection.values) {totalPrograms.addAll(list);}
    totalPrograms = totalPrograms.unique();
    maxSize = totalPrograms.length;
  }


  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    if (!loadMore) {
      reset();
    }
    int skip = currentIndex * pageSize;
    programs.addAll(
        totalPrograms.getRange(skip, skip + min(pageSize, maxSize - skip)));
    pageIndex = currentIndex;
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void dispose() {
    MyNavigator().removeListener(listener);
    super.dispose();
  }
}
