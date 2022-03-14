import 'package:flutter/material.dart';
import 'package:smart_tv_guide/pages/home_page.dart';
import 'package:smart_tv_guide/pages/my_page.dart';
import 'package:smart_tv_guide/pages/search_page.dart';
import 'package:smart_tv_guide/pages/hot_page.dart';
import 'package:smart_tv_guide/tools/shared_variables.dart';

import 'hi_navigator.dart';

class TabNavigator extends StatefulWidget {
  @override
  State<TabNavigator> createState() => _TabNavigatorState();

  const TabNavigator({Key? key}) : super(key: key);
}

class _TabNavigatorState extends State<TabNavigator> {
  late final PageController _controller;
  final _activeColor = Colors.redAccent;
  int _currentIndex = 0;
  static int initialPage = 0;
  late List<Widget> _pages;
  bool _built = false;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex, keepPage: true);
    _pages = [
      HomePage(onJumpTo: (index) => _onJumpTo(index)),
      const HotPage(),
      const SearchPage(),
      const MinePage(),
    ];
    if (!_built) {
      //页面第一次打开时通知打开的是那个tab
      HiNavigator().onBottomTabChange(_pages[initialPage]);
      _built = true;
    }
    Share.map['pageControl'] = _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        selectedItemColor: _activeColor,
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomNavigationBarItem('Home', Icons.home),
          _bottomNavigationBarItem('Hot', Icons.local_fire_department),
          _bottomNavigationBarItem('Search', Icons.search),
          _bottomNavigationBarItem('Mine', Icons.account_circle),
        ],
      ),
    );
  }

  _bottomNavigationBarItem(String label, IconData? icon) =>
      BottomNavigationBarItem(
        label: label,
        icon: Icon(icon),
        activeIcon: Icon(icon),
      );

  void _onJumpTo(int index, {pageChange = false}) {
    if (pageChange) {
      HiNavigator().onBottomTabChange(_pages[index]);
    } else {
      //让PageView展示对应tab
      _controller.jumpToPage(index);
    }
    setState(() {
      //控制选中第一个tab
      _currentIndex = index;
    });
  }
}
