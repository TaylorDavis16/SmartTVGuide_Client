import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../dao/channel_dao.dart';

class HotTabHottestPage extends StatefulWidget {
  const HotTabHottestPage({Key? key}) : super(key: key);

  @override
  _HotTabHottestPageState createState() => _HotTabHottestPageState();
}

class _HotTabHottestPageState extends HotTabState<HotTabHottestPage> {
  _HotTabHottestPageState() : super(needSwiper: true, needLogin: true);
  List recommendation = [];
  Map apiData = ChannelDao.apiMap();

  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    if (!loadMore) {
      programs.clear();
      bannerList = renewBannerList();
      recommendation = await ProgramDao.hotProgramData();
      Set<String> set = {};
      for (var e in recommendation) {
        apiData[e.channel].forEach((v) => set.add(v));
      }
      logger.w(set);
      List all = Hive.box('home').get('programs');
      all.shuffle(random());
      List sameClass = all.where((e) => set.contains(e.channel)).toList();
      recommendation.addAll(sameClass);
      recommendation.shuffle(random());
      recommendation.addAll(all);
      recommendation.unique();
      maxSize = recommendation.length;
      logger.w(maxSize);
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
