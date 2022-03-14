import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

import '../util/view_util.dart';

class ChannelDetail extends StatefulWidget {
  final Channel channel;

  const ChannelDetail(this.channel, {Key? key}) : super(key: key);

  @override
  _ChannelDetailState createState() => _ChannelDetailState();
}

class _ChannelDetailState extends BaseState<ChannelDetail> {
  late List<Map<String, dynamic>> _items;
  bool marked = false;
  late Random random;
  late List<Color> colors;

  void _init() {
    _items = configList(widget.channel.programs.length, random);
    colors = [];
    for (int i = 0; i < widget.channel.programs.length; i++) {
      colors.add(Color.fromARGB(random.nextInt(256), random.nextInt(256),
          random.nextInt(256), random.nextInt(256)));
    }
  }

  @override
  void initState() {
    random = Random();
    super.initState();
  }

  @override
  get contentChild {
    List<Program> programs = widget.channel.programs;
    return Scaffold(
      appBar: appBar(
          widget.channel.displayName,
          marked ? 'Remove' : 'Add',
          () => setState(() {
                marked = !marked;
              }),
          icon: marked ? Icons.favorite : Icons.favorite_border_outlined),
      body: MasonryGridView.count(
        itemCount: programs.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        // the number of columns
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          // display each item with a card
          return Card(
            // Give each item a random background color
            color: colors[index],
            key: ValueKey(_items[index]['id']),
            child: SizedBox(
              height: _items[index]['height'],
              child: InkWell(
                onTap: () => gotoProgram(programs[index]),
                child: Center(
                  child: Text(programs[index].title),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> loadData({loadMore = false}) async {
    setState(() {
      _init();
    });
  }
}
