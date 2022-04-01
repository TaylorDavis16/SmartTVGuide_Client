import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/model/hot_program_model.dart';

class HotTabHottestPage extends StatefulWidget {
  const HotTabHottestPage({Key? key}) : super(key: key);

  @override
  _HotTabHottestPageState createState() => _HotTabHottestPageState();
}

class _HotTabHottestPageState extends HotTabState<HotTabHottestPage> {
  _HotTabHottestPageState() : super(needSwiper: true, needLogin: true);

  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    HotProgramModel model = await ProgramDao.hotProgramData(currentIndex, pageSize);
    if (loadMore) {
      programs.addAll(model.programs);
      pageIndex = currentIndex;
    } else {
      bannerList = renewBannerList();
      programs = model.programs;
      maxSize = model.maxSize;
    }
    setState(() {});
  }


}
