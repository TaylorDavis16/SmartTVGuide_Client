import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/http/core/route_jump_listener.dart';
import 'package:smart_tv_guide/navigator/my_navigator.dart';

import '../../dao/user_dao.dart';
import '../../model/channel.dart';
import '../../util/app_util.dart';
import '../../widget/hi_banner.dart';
import '../../widget/loading_container.dart';
import '../../widget/program_card.dart';

abstract class HotTabState<T extends StatefulWidget> extends BaseState<T> {
  bool needSwiper;
  int pageSize;
  bool needLogin;

  HotTabState(
      {this.needSwiper = false, this.needLogin = false, this.pageSize = 20})
      : super(removeTop: true, needScrollController: true);
  List programs = [];
  List<Channel> bannerList = [];
  bool isLoading = true;
  int maxSize = 0;

  @override
  Future<void> loadData({loadMore = false}) async {
    if (needLogin) {
      if (UserDao.hasLogin()) {
        super.loadData(loadMore: loadMore);
      }
    } else {
      super.loadData(loadMore: loadMore);
    }
  }

  @override
  get contentChild {
    var content = LoadingContainer(
      isLoading: isLoading,
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: programs.length + (needSwiper ? 1 : 0),
          controller: scrollController,
          itemBuilder: (BuildContext context, int index) => needSwiper
              ? _item(index)
              : ProgramCard(program: programs[index])),
    );
    if (needLogin) {
      return UserDao.hasLogin()
          ? content
          : GestureDetector(
              child: const Center(
                child: Text(
                  'Login to see more',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () => MyNavigator().onJumpTo(RouteStatus.login),
            );
    }
    return content;
  }

  @override
  Future<void> customLoad({loadMore = false}) async {
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    if (currentIndex * pageSize <= maxSize) {
      try {
        await load(currentIndex, loadMore: loadMore);
      } catch (e) {
        logger.e(e);
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      stopLoading = true;
    }
  }

  Future<void> load(int currentIndex, {loadMore = false}) async {}

  _item(int index) {
    if (index == 0) {
      return HiBanner(bannerList);
    }
    return ProgramCard(program: programs[index - 1]);
  }

  List<Channel> renewBannerList({int num = 3}) {
    var homeBox = Hive.box('home');
    Map map = homeBox.get('channelMap');
    List<String> banners = homeBox.get('channels');
    if (num > banners.length) num = banners.length - 3;
    return banners
        .skip(random().nextInt(banners.length - num + 1))
        .take(num)
        .map((e) => map[e] as Channel)
        .toList();
  }
}
