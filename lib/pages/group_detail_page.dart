import 'package:flutter/material.dart';
import 'package:smart_tv_guide/model/group.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

import '../util/color.dart';
import '../widget/my_expansion_tile.dart';

class GroupDetail extends StatefulWidget {
  final Group group;

  const GroupDetail(this.group, {Key? key}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.group.name),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text(
                  'This is ${widget.group.name} created by ${widget.group.members[widget.group.owner.toString()]}'),tileColor: randomColor()
            ),
            ListTile(
              title: Text('Created at: ${widget.group.begin.toString()}'),tileColor: randomColor()
            ),
            MyExpansionTile(
              origin: widget.group.members.values.toList(),
              title: 'Members',
              toElement: (dynamic member) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: randomColor(),
                  ),
                  title: Text(member)),
            ),
          ],
        ),
      ),
    );
  }
}
