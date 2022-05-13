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
  List all = Hive.box('home').get('programs').where((e) => DateTime.now().compareTo(e.start) <= 0).toList();

  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    if (!loadMore) {
      programs.clear();
      bannerList = renewBannerList();
      recommendation = await ProgramDao.hotProgramData();
      Set<String> set = {};
      for (var e in recommendation) {
        apiData[e.channel]?['categories']?.forEach((v) => set.add(v));
      }
      logger.i(set);
      all.shuffle(random());
      List sameClass = all.where((e) => condition(e, set)).toList();
      List other = all.where((e) => !condition(e, set)).toList();
      logger.i(sameClass.length);
      logger.i(other.length);
      sameClass.addAll(other.take((){
        if(other.length > sameClass.length) {
          return sameClass.length < 100 ? other.length : sameClass.length ~/ 2;
        } else {
          return other.length;
        }
      }()).toList());
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

  bool condition(dynamic e, Set set) {
    if(DateTime.now().compareTo(e.start) > 0) {
      return false;
    }
    if(apiData[e.channel] != null){
      return apiData[e.channel]['categories']?.any((c) => set.contains(c));
    }
    return false;
  }


}
