import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/util/app_util.dart';

class HotTabHottestPage extends StatefulWidget {
  const HotTabHottestPage({Key? key}) : super(key: key);

  @override
  _HotTabHottestPageState createState() => _HotTabHottestPageState();
}

class _HotTabHottestPageState extends HotTabState<HotTabHottestPage> {
  _HotTabHottestPageState() : super(needSwiper: true, needLogin: true);
  List recommendation = [];

  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    if (!loadMore) {
      programs.clear();
      bannerList = renewBannerList();
      recommendation = await ProgramDao.hotProgramData();
      List all = Hive.box('home').get('programs');
      all.shuffle(random());
      recommendation.shuffle(random());
      recommendation.addAll(all);
      maxSize = recommendation.length;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    int skip = currentIndex * pageSize;
    if (skip <= maxSize) {
      programs.addAll(
          recommendation.getRange(skip, skip + min(pageSize, maxSize - skip)));
      pageIndex = currentIndex;
      isLoading = false;
      setState(() {});
    } else {
      stopLoading = true;
    }
    setState(() {});
  }


}
