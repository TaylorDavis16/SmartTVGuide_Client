import 'package:flutter/material.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

class ProgramDetail extends StatefulWidget {
  final Program program;
  const ProgramDetail(this.program,{Key? key}) : super(key: key);

  @override
  _ProgramDetailState createState() => _ProgramDetailState();
}

class _ProgramDetailState extends State<ProgramDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.program.title, 'Something', () => {}),
      body: ListView(
        children: [
          Text(widget.program.about),
          Text(widget.program.channel),
          Text(widget.program.title),
          Text(widget.program.start.toString()),
          Text(widget.program.stop.toString()),
          Text(widget.program.lang),
        ],
      )
    );
  }
}
