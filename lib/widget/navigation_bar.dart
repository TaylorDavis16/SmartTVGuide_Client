import 'package:flutter/material.dart';

///可自定义样式的沉浸式导航栏
class MyNavigationBar extends StatefulWidget {
  final Color color;
  final double height;
  final Widget? child;

  const MyNavigationBar(
      {Key? key, this.color = Colors.white, this.height = 46, this.child})
      : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
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
