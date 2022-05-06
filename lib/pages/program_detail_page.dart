import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/color.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

import '../dao/user_dao.dart';
import '../util/app_util.dart';
import '../widget/multi_select_box.dart';

class ProgramDetail extends StatefulWidget {
  final Program program;

  const ProgramDetail(this.program, {Key? key}) : super(key: key);

  @override
  _ProgramDetailState createState() => _ProgramDetailState();
}

class _ProgramDetailState extends State<ProgramDetail>
    with MultiSelectSupport<ProgramDetail> {
  bool marked = false;
  late final Program _program;

  @override
  void initState() {
    if (UserDao.hasLogin()) {
      Program p = widget.program;
      _program = Program(
          p.channel,
          p.title.replaceAll(RegExp(r'[0-9\-()（）・:：\s]+'), ''),
          p.lang,
          p.start,
          p.stop,
          p.about);
      _refresh(true);
    }

    super.initState();
  }

  @override
  void sort(List list) => sortNames(list);

  void _like() async {
    UserDao.ensureLogin(() => showMultiSelect());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(widget.program.title,
            rightTitle: marked ? 'Remove' : 'Add',
            rightButtonClick: () => _like(),
            icon: marked ? Icons.favorite : Icons.favorite_border_outlined),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                  title: Text(
                      'Intro: This is ${widget.program.title} from ${widget.program.channel}'),
                  tileColor: randomColor()),
              ListTile(
                  title: Text('Channel ID: ${widget.program.channel}'),
                  tileColor: randomColor()),
              ListTile(
                  title: Text('Name: ${widget.program.title}'), tileColor: randomColor()),
              ListTile(
                  title: Text('Start: ${widget.program.start.toString()}'),
                  tileColor: randomColor()),
              ListTile(
                  title: Text('Stop: ${widget.program.stop.toString()}'),
                  tileColor: randomColor()),
              ListTile(
                  title: Text('Language: ${widget.program.lang}'), tileColor: randomColor()),
            ],
          ),
        ));
  }

  @override
  Map<String, bool> fetch() {
    Map<String, bool> selectBoxOptions = UserDao.getProgramCollection()
        .map((key, list) => MapEntry(key, list.contains(_program)));
    return selectBoxOptions;
  }

  @override
  String get selectBoxName => 'Program Collection';

  @override
  Future<void> updateDB(Map<String, bool> changes, int change) async {
    var success = await ProgramDao.updateData(changes, _program, change);
    _refresh(success);
  }

  _refresh(bool refresh) {
    if (refresh) {
      setState(() {
        marked = UserDao.containsProgram(_program);
      });
    }
  }
}
