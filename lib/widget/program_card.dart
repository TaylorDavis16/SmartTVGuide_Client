import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../util/format_util.dart';
import '../util/view_util.dart';

///关联视频，视频列表卡片
class ProgramCard extends StatelessWidget {
  static final Map channelMap = Hive.box('home').get('channelMap');
  final Program program;

  const ProgramCard({Key? key, required this.program}) : super(key: key);

  Channel theChannel() => channelMap[program.channel];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => gotoProgram(program),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: const EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(children: [
          _itemImage(context),
          _buildContent(),
        ]),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          SizedBox(
            width: height * (16 / 9),
            height: height,
            child: Center(
              child: cachedImage(theChannel(),
                  fit: BoxFit.fitWidth),
            ),
          ),
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  dateHourAndMinute(program.start!) + '-' +dateHourAndMinute(program.stop!),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ))
        ],
      ),
    );
  }

  _buildContent() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(top: 5, left: 8, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            program.title,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _buildBottomContent()
        ],
      ),
    ));
  }

  _buildBottomContent() {
    return Column(
      children: [
        //作者
        _owner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ...smallIconText(Icons.language, program.lang),
              ],
            ),
          ],
        )
      ],
    );
  }

  _owner() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          child: const Text(
            'Channel',
            style: TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        hiSpace(width: 8),
        Text(
          theChannel().displayName,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        )
      ],
    );
  }
}
