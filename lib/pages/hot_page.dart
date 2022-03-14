import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/http/core/hi_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/pages/hot_tab_page.dart';
import 'package:smart_tv_guide/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';
import '../http/core/hi_error.dart';
import '../util/app_util.dart';
import '../util/toast.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends HiState<HotPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<Channel> channelList = [];
  late TabController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
    logger.i("xxxxxxxx");
    logger.i('${channelList.length}');
    _controller = TabController(length: channelList.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // appBar: appBar(
      //     "Hot Channel", "Refresh", () => log('123'), centerTitle: true),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30),
            child: _tabBar(),
          ),
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: channelList
                .map((channel) =>
                    HotTabPage(channel.displayName, channel.programs))
                .toList(),
          )),
        ],
      ),
    );
  }

  _tabBar() {
    return TabBar(
      tabs: channelList
          .map<Tab>((channel) => Tab(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    channel.displayName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ))
          .toList(),
      controller: _controller,
      isScrollable: true,
      indicator: const UnderlineIndicator(
          strokeCap: StrokeCap.round,
          borderSide: BorderSide(color: primary),
          insets: EdgeInsets.only(left: 15, right: 15)),
    );
  }

  void loadData() async {
    try {
      List<Channel> channels = await ChannelDao.getAll();
      if (channels.isNotEmpty) {
        //tab长度变化后需要重新创建TabController
        _controller = TabController(length: channels.length, vsync: this);
      }
      setState(() {
        channelList = channels;
        for (var channel in channelList) {
          channel.programs
              .sort((p1, p2) => p1.start!.isAfter(p2.start!) ? 1 : -1);
        }
        // channelList.sort((c1, c2) => c2.programs.length - c1.programs.length);
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      logger.i(e.toString());
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      logger.i(e.toString());
      showWarnToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
