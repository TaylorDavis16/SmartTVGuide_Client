import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/model/home_model.dart';
import 'package:smart_tv_guide/util/view_util.dart';
import '../model/channel.dart';
import '../navigator/hi_navigator.dart';
import '../util/app_util.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  var listener;
  late Widget _currentPage;
  late List<Map<String, dynamic>> _items;
  late Random random;
  List<Channel> channelList = [];
  List<Channel> bannerList = [];
  late List<Color> colors;
  int pageSize = 16;
  int maxSize = 0;

  _HomePageState() : super(removeTop: true, needScrollController: true);

  @override
  void initState() {
    random = Random();
    super.initState();
    HiNavigator().addListener(listener = (current, pre) {
      _currentPage = current.page;
      logger.i('home:current:${current.page}');
      logger.i('home:pre:${pre.page}');
      if (widget == _currentPage || _currentPage is HomePage) {
        logger.i('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        logger.i('首页:onPause');
      }
      //当页面返回到首页恢复首页的状态栏样式
      // if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
      //   var statusStyle = StatusStyle.DARK_CONTENT;
      //   changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    HiNavigator().removeListener(listener);
  }

  ///监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    logger.i(':didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  get contentChild {
    return MasonryGridView.count(
      controller: scrollController,
      itemCount: channelList.length,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      // the number of columns
      crossAxisCount: 2,
      // vertical gap between two items
      mainAxisSpacing: 4,
      // horizontal gap between two items
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        // display each item with a card
        Channel channel = channelList[index];
        return Card(
          // Give each item a random background color
          color: colors[index],
          key: ValueKey(_items[index]['id']),
          child: SizedBox(
            height: _items[index]['height'],
            child: InkWell(
              onTap: () => gotoChannel(channel),
              child: Center(
                child: cachedImage(channel.imgURL, channel.displayName),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> customLoad({loadMore = false}) async {
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    if (currentIndex * pageSize <= maxSize) {
      HomeModel homeModel = await ChannelDao.homeData(
          swiper: !loadMore, pageIndex: currentIndex, pageSize: pageSize);
      if (homeModel.channels.isNotEmpty) {
        setState(
          () {
            if (loadMore) {
              channelList.addAll(homeModel.channels);
              pageIndex = currentIndex;
              _items.addAll(configList(homeModel.channels.length, random));
            } else {
              bannerList = homeModel.bannerList;
              channelList = homeModel.channels;
              maxSize = homeModel.maxSize;
              _items = configList(homeModel.channels.length, random);
              colors = [];
            }
            _colorFill(channelList.length);
          },
        );
      }
    }
    else {
      stopLoading = true;
    }
  }

  void _colorFill(int length) {
    for (int i = colors.length; i < length; i++) {
      colors.add(Color.fromARGB(random.nextInt(256), random.nextInt(256),
          random.nextInt(256), random.nextInt(256)));
    }
  }
}
