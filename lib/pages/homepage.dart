import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/http/core/my_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/model/home_model.dart';
import 'package:smart_tv_guide/pages/home_tab_page.dart';
import 'package:smart_tv_guide/widget/loading_container.dart';
import 'package:smart_tv_guide/widget/my_tab.dart';

import '../http/core/request_error.dart';
import '../util/app_util.dart';
import '../util/view_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends MyState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  static final _homeBox = Hive.box('home');
  List<List<String>> channelNameList = [];
  List<String> tabNames = [];
  TabController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingContainer(
        isLoading: _isLoading,
        child: Scaffold(
          body: Column(
            children: [
              _tab(),
              _content(),
            ],
          ),
        ));
  }

  _tab() => Container(
        color: Colors.grey,
        padding: const EdgeInsets.only(top: 30),
        child: MyTab(
          tabNames
              .map<Tab>((name) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ))
              .toList(),
          controller: _controller,
        ),
      );

  _content() => Flexible(
          child: TabBarView(
        controller: _controller,
        children: channelNameList
            .map((channelNames) => HomeTabPage(channelNames))
            .toList(),
      ));

  bool testKeyword(String channelName, String keyword) {
    return channelName.contains(keyword);
  }

  void handleData() async{
    List apiData = await ChannelDao.apiData();
    logger.i(apiData.length);
    _homeBox.put('api', { for (var datum in apiData) datum['id'] : datum });
  }

  void loadData() async {
    try {
      if (!_homeBox.containsKey('channelMap')) {
        HomeModel model = await ChannelDao.homeData();
        _homeBox.put('channelMap', model.channelMap);
        _homeBox.put('channels',
            model.channelMap.values.map<String>((e) => e.id).toList());
        _collectProgram(model);
      }
      handleData();
      List<String> channelsId = _homeBox.get('channels');
      tabNames = ['All', 'Beijing', 'CCTV', 'NBTV', 'Other'];
      channelNameList
        ..add(channelsId)
        ..add(channelsId.where((e) => testKeyword(e, 'Beijing')).toList())
        ..add(channelsId.where((e) => testKeyword(e, 'CCTV')).toList())
        ..add(channelsId.where((e) => testKeyword(e, 'NBTV')).toList())
        ..add(channelsId
            .where((e) => !(testKeyword(e, 'Beijing') ||
                testKeyword(e, 'CCTV') ||
                testKeyword(e, 'NBTV')))
            .toList());
      setState(() {
        _controller = TabController(length: 5, vsync: this);
        _isLoading = false;
      });
    } on RequestError catch (e) {
      logger.i(e.toString());
      showWarnToast('Network Error');
    }
  }

  _collectProgram(HomeModel model) {
    List<Program> allPrograms = [];
    for (var entry in model.channelMap.entries) {
      allPrograms.addAll(entry.value.programs);
    }
    _homeBox.put('programs', allPrograms);
  }

  @override
  bool get wantKeepAlive => true;
}
