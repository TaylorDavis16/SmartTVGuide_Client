import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/model/hot_program_model.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/toast.dart';
import 'package:smart_tv_guide/widget/hi_banner.dart';

import '../widget/loading_container.dart';
import '../widget/program_card.dart';

class HotTabPage extends StatefulWidget {
  final String name;
  final int index;
  final bool needSwiper;

  const HotTabPage(
      {Key? key,
      required this.name,
      required this.index,
      this.needSwiper = false})
      : super(key: key);

  @override
  _HotTabPageState createState() => _HotTabPageState();
}

class _HotTabPageState extends BaseState<HotTabPage> {
  _HotTabPageState() : super(removeTop: true, needScrollController: true);

  List<Program> programs = [];
  List<Channel> bannerList = [];
  bool _isLoading = true;
  int pageSize = 10;
  int maxSize = 0;

  @override
  get contentChild => LoadingContainer(
        isLoading: _isLoading,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10),
            itemCount: programs.length + (widget.needSwiper ? 1 : 0),
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) => _item(index)),
      );

  _item(int index) {
    if (widget.needSwiper) {
      if (index == 0) {
        return HiBanner(bannerList);
      }
      return ProgramCard(program: programs[index - 1]);
    }
    return ProgramCard(program: programs[index]);
  }

  @override
  Future<void> customLoad({loadMore = false}) async {
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    if (currentIndex * pageSize <= maxSize) {
      try {
        if (widget.index != 3) {
          HotProgramModel model = await ProgramDao.hotData(
              widget.index, currentIndex, pageSize,
              swiper: !loadMore);
          logger.i(model);
          _handleProgramData(model, currentIndex, loadMore: loadMore);
        } else {
          print('Not yet implement!');
        }
      } catch (e){
        logger.e(e);
        showWarnToast('Network Error');
      } finally {
        setState(() {_isLoading = false;});
      }
    } else {
      stopLoading = true;
    }
  }

  _handleProgramData(HotProgramModel model, int currentIndex,
      {loadMore = false}) {
    if (model.programs.isNotEmpty) {
      if (loadMore) {
        programs.addAll(model.programs);
        pageIndex = currentIndex;
      } else {
        bannerList = model.bannerList;
        programs = model.programs;
        maxSize = model.maxSize;
      }
    }
  }
}
