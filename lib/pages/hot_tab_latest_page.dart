import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/util/app_util.dart';

class HotTabLatestPage extends StatefulWidget {
  const HotTabLatestPage({Key? key}) : super(key: key);

  @override
  _HotTabLatestPageState createState() => _HotTabLatestPageState();
}

class _HotTabLatestPageState extends HotTabState<HotTabLatestPage> {
  _HotTabLatestPageState() : super(needSwiper: true, pageSize: 30);
  final List totalPrograms = Hive.box('home').get('programs');

  @override
  void initState() {
    maxSize = totalPrograms.length;
    super.initState();
  }

  @override
  Future<void> customLoad({loadMore = false}) async {
    if (!loadMore) {
      totalPrograms.shuffle(random());
      programs.clear();
      bannerList = renewBannerList();
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    int skip = currentIndex * pageSize;
    if (skip <= maxSize) {
      programs.addAll(
          totalPrograms.getRange(skip, skip + min(pageSize, maxSize - skip)));
      pageIndex = currentIndex;
      isLoading = false;
      setState(() {});
    } else {
      stopLoading = true;
    }
  }
}
