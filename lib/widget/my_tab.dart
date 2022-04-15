import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

///顶部tab切换组件
class MyTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController? controller;
  final double fontSize;
  final double borderWidth;
  final double insets;
  final Color unselectedLabelColor;

  const MyTab(this.tabs,
      {Key? key,
      this.controller,
      this.fontSize = 16,
      this.borderWidth = 3,
      this.insets = 15,
      this.unselectedLabelColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: Colors.red,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(fontSize: fontSize),
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.square,
            borderSide: BorderSide(color: Colors.red, width: borderWidth),
            insets: EdgeInsets.only(left: insets, right: insets)),
        tabs: tabs);
  }
}
