import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/core/hot_tab_state.dart';
import 'package:smart_tv_guide/model/hot_program_model.dart';

class HotTabCollectionPage extends StatefulWidget {
  const HotTabCollectionPage({Key? key}) : super(key: key);

  @override
  _HotTabCollectionPageState createState() => _HotTabCollectionPageState();
}

class _HotTabCollectionPageState extends HotTabState<HotTabCollectionPage> {
  _HotTabCollectionPageState() : super(needLogin: true);

  @override
  Future<void> load(int currentIndex, {loadMore = false}) async {
    HotProgramModel model = await ProgramDao.hotCollectionData(currentIndex, pageSize);
    if (loadMore) {
      programs.addAll(model.programs);
      pageIndex = currentIndex;
    } else {
      programs = model.programs;
      maxSize = model.maxSize;
    }
  }


}
