import 'package:flutter/material.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

import '../navigator/my_navigator.dart';
import '../widget/program_card.dart';

class CollectionProgramFolderPage extends StatefulWidget {
  final Map items;
  const CollectionProgramFolderPage(this.items, {Key? key}) : super(key: key);

  @override
  State<CollectionProgramFolderPage> createState() => _CollectionProgramFolderPageState();
}

class _CollectionProgramFolderPageState extends State<CollectionProgramFolderPage> {
  late List programs = widget.items['list'];
  late RouteChangeListener listener;
  @override
  void initState() {
    super.initState();
    MyNavigator().addListener(listener = (current, pre) {
      if(widget == current.page && pre.page is ProgramDetail){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.items['title']),
      body: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          itemCount: programs.length,
          itemBuilder: (BuildContext context, int index) => ProgramCard(program: programs[index])),
    );
  }

  @override
  void dispose() {
    MyNavigator().removeListener(listener);
    super.dispose();
  }
}
