import 'package:flutter/material.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/navigator/hi_navigator.dart';
import 'package:smart_tv_guide/widget/login_button.dart';

class HotTabPage extends StatefulWidget {
  final String? categoryName;
  final List<Program> programList;

  const HotTabPage(this.categoryName, this.programList, {Key? key})
      : super(key: key);

  @override
  _HotTabPageState createState() => _HotTabPageState();
}

class _HotTabPageState extends State<HotTabPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    print(widget.categoryName);
  }


  @override
  bool get wantKeepAlive => true;


  @override
  Future getData(int pageIndex) {
    return Future.value(16);
  }

  @override
  List parseList(result) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return _child();
  }

  _child() {
    if (widget.programList.isNotEmpty) {
      return Padding(padding: const EdgeInsets.only(bottom: 8), child: ListView(
        children: widget.programList.map<Widget>((program) =>
            LoginButton(program.title, onPressed: () => HiNavigator().onJumpTo(RouteStatus.programDetail, args: {"program": program}),)).toList(),
      ),);
    }
    return const Text('Empty! Sorry');
  }


}
