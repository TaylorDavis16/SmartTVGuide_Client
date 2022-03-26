import 'package:flutter/material.dart';
import 'package:smart_tv_guide/pages/homepage.dart';
import 'package:smart_tv_guide/pages/hot_page.dart';
import 'package:smart_tv_guide/pages/my_page.dart';
import 'package:smart_tv_guide/pages/search_page.dart';

import '../tools/shared_variables.dart';
import 'my_navigator.dart';

class TabNavigator extends StatefulWidget {
  @override
  State<TabNavigator> createState() => _TabNavigatorState();
  final int initialPage;
  const TabNavigator({Key? key, this.initialPage = 0}) : super(key: key);
}

class _TabNavigatorState extends State<TabNavigator> {
  late final PageController _controller;
  final _activeColor = Colors.redAccent;
  late int _currentIndex;
  late List<Widget> _pages;
  bool _built = false;

  @override
  void initState() {
    _currentIndex = widget.initialPage;
    super.initState();
    _controller = PageController(initialPage: _currentIndex, keepPage: true);
    _pages = [
      const HomePage(),
      const HotPage(),
      const SearchPage(),
      const MinePage(),
    ];
    if (!_built) {
      //页面第一次打开时通知打开的是那个tab
      MyNavigator().onBottomTabChange(_pages[_currentIndex]);
      _built = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => MyNavigator().onBottomTabChange(_pages[index]),
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Share.brightness,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => _jumpToPage(index),
          selectedItemColor: _activeColor,
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomNavigationBarItem('Home', Icons.home),
            _bottomNavigationBarItem('Hot', Icons.local_fire_department),
            _bottomNavigationBarItem('Search', Icons.search),
            _bottomNavigationBarItem('Mine', Icons.account_circle),
          ],
        ),
      ),
    );
  }

  _bottomNavigationBarItem(String label, IconData? icon) =>
      BottomNavigationBarItem(
        label: label,
        icon: Icon(icon),
        activeIcon: Icon(icon),
        tooltip: ''
      );

  void _jumpToPage(int index) {
    if(_currentIndex != index){
      _controller.jumpToPage(index);
      setState(() {
        //控制选中第一个tab
        _currentIndex = index;
      });
    }
  }
}
