import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/color.dart';
import 'package:smart_tv_guide/widget/program_card.dart';

import '../util/view_util.dart';
import '../widget/my_expansion_tile.dart';

class ProgramSearchPage extends StatefulWidget {
  const ProgramSearchPage({Key? key}) : super(key: key);

  @override
  State<ProgramSearchPage> createState() => _ProgramSearchPageState();
}

class _ProgramSearchPageState extends State<ProgramSearchPage> {
  final TextEditingController controller = TextEditingController();
  List<dynamic> channels = [];
  List<dynamic> programs = [];
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.extentAfter == 0) {
        bottomMessage(context, 'You have reached the end');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: search(''),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      if (channels.isNotEmpty)
                        if (channels.isNotEmpty)
                          MyExpansionTile(
                            origin: channels,
                            subtitle: 'Channel',
                            title: 'Related channels',
                            toElement: (dynamic channel) => ListTile(
                                onTap: () => gotoChannel(channel as Channel),
                                leading: CircleAvatar(
                                  backgroundColor: randomColor(),
                                ),
                                title: Text(channel.displayName)),
                          ),
                      if (programs.isNotEmpty)
                        MyExpansionTile(
                            origin: programs,
                            title: 'Program',
                            subtitle: 'Related programs',
                            toElement: (dynamic program) =>
                                ProgramCard(program: program)),
                    ],
                  ),
                )
              : const Center(
                  child: Text(
                    'Loading......Please Wait',
                    style: TextStyle(fontSize: 30),
                  ),
                );
          return Scaffold(
            appBar: AppBar(
              // The search area here
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.keyboard),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.clear(),
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none),
                  ),
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () => search(controller.text.trim()),
                    icon: const Icon(Icons.search))
              ],
            ),
            body: widget,
          );
        });
  }

  Future<void> search(String characters) async {
    if (characters != '') {
      setState(() {});
      String origin = characters;
      characters =
          PinyinHelper.getPinyinE(characters, separator: '').toLowerCase();
      logger.i(characters);
      Map map = Hive.box('home').get("channelMap");
      List allPrograms = Hive.box('home').get("programs");
      //先按名字搜索，再按id搜索
      RegExp exp = RegExp("^[\\u4e00-\\u9fa5]+\$");
      if (exp.hasMatch(origin)) {
        channels = map.values
            .where((channel) => (channel.displayName.contains(origin)))
            .toList();
      } else {
        channels = map.values
            .where((channel) =>
                _isMatchedPinyin(channel.displayName, characters) ||
                channel.id.toLowerCase().contains(characters))
            .toList();
      }
      if (exp.hasMatch(origin)) {
        programs = allPrograms
            .where((program) => program.title.contains(origin))
            .toList()
            .unique();
      } else {
        programs = allPrograms
            .where((program) => _isMatchedPinyin(program.title, characters))
            .toList()
            .unique();
      }
    }
  }

  bool _isMatchedPinyin(String text, String characters) =>
      PinyinHelper.getPinyinE(text, separator: '')
          .toLowerCase()
          .contains(characters);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _controller.dispose();
  }
}
