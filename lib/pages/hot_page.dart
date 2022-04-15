import 'package:flutter/material.dart';
import 'package:smart_tv_guide/pages/hot_tab_collection_page.dart';
import 'package:smart_tv_guide/pages/hot_tab_latest_page.dart';
import 'package:smart_tv_guide/widget/my_tab.dart';
import 'package:smart_tv_guide/widget/navigation_bar.dart';

import '../util/view_util.dart';
import 'hot_tab_hottest_page.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static const tabs = ["Latest", "Hottest", "Favorite"];
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return MyNavigationBar(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _tabBar() {
    return Container(
        color: Colors.white,
        child: MyTab(tabs.map<Tab>((tab) => Tab(text: tab)).toList(),
            unselectedLabelColor: Colors.black54,
            controller: _controller));
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(controller: _controller, children: const [
        HotTabLatestPage(),
        HotTabHottestPage(),
        HotTabCollectionPage()
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
