import 'package:flutter/material.dart';
import 'package:smart_tv_guide/widget/my_tab.dart';
import 'package:smart_tv_guide/widget/navigation_bar.dart';

import '../util/view_util.dart';
import 'hot_tab_page.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage>
    with TickerProviderStateMixin {
  static const tabs = [
    {"key": "hot", "name": "Hottest", "index" : 1},
    {"key": "new", "name": "Latest", "index" : 2},
    {"key": "collection", "name": "Favorite", "index" : 3}
  ];
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
    return Scaffold(
      body: Column(
        children: [_buildNavigationBar(), _buildTabView()],
      ),
    );
  }

  _buildNavigationBar() {
    return SearchBar(
      child: Container(
        decoration: bottomBoxShadow(),
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _tabBar() {
    return MyTab(
        tabs.map<Tab>((tab) {
          return Tab(
            text: tab['name'] as String,
          );
        }).toList(),
        fontSize: 16,
        borderWidth: 3,
        unselectedLabelColor: Colors.black54,
        controller: _controller);
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(
          controller: _controller,
          children:
              tabs.map((tab) => HotTabPage(name: tab['name'] as String, index: tab['index'] as int, needSwiper: tab['index'] != 'collection',)).toList()),
    );
  }
}
