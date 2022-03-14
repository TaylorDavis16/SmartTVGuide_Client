import 'package:flutter/material.dart';

///可自定义样式的沉浸式导航栏
class SearchBar extends StatefulWidget {
  final Color color;
  final double height;
  final Widget? child;

  const SearchBar(
      {Key? key, this.color = Colors.white, this.height = 46, this.child})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //状态栏高度
    var top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
    );
  }
}
