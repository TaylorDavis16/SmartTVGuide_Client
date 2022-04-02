import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/widget/appbar.dart';
import 'package:smart_tv_guide/widget/multi_select_box.dart';

import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';
import '../util/color.dart';
import '../util/view_util.dart';

class ChannelDetail extends StatefulWidget {
  final Channel channel;

  const ChannelDetail(this.channel, {Key? key}) : super(key: key);

  @override
  _ChannelDetailState createState() => _ChannelDetailState();
}

class _ChannelDetailState extends BaseState<ChannelDetail>
    with MultiSelectSupport<ChannelDetail> {
  late List<Map<String, dynamic>> _items;
  bool marked = false;
  late List<Color> colors;

  @override
  Future<void> refresh() async {
    colors = List.generate(_items.length, (_) => randomColor());
    loadData();
  }

  @override
  void initState() {
    _refresh(UserDao.hasLogin());
    _items = configList(widget.channel.programs.length);
    colors = List.generate(_items.length, (_) => randomColor());
    super.initState();
  }

  @override
  void sort(List list) => sortNames(list);

  void _like() async {
    if (UserDao.hasLogin()) {
      showMultiSelect();
    } else {
      showWarnToast('Please login');
      MyNavigator().onJumpTo(RouteStatus.login);
    }
  }

  @override
  get contentChild {
    List<Program> programs = widget.channel.programs;
    return Scaffold(
      appBar: appBar(
          widget.channel.displayName, rightTitle: marked ? 'Remove' : 'Add', rightButtonClick: () => _like(),
          icon: marked ? Icons.favorite : Icons.favorite_border_outlined),
      body: MasonryGridView.count(
        itemCount: programs.length,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
    setState(() {});
  }

  @override
  String get selectBoxName => 'Channel Collection';

  @override
  Map<String, bool> fetch() {
    Map<String, bool> selectBoxOptions = UserDao.getChannelCollection()
        .map((key, list) => MapEntry(key, list.contains(widget.channel.id)));
    return selectBoxOptions;
  }

  @override
  Future<void> updateDB(Map<String, bool> changes, int change) async {
    var success = await ChannelDao.updateData(changes, widget.channel.id, change);
    _refresh(success);
  }

  _refresh(bool refresh) {
    if(refresh){
      setState(() {
        marked = UserDao.containsChannel(widget.channel.id);
      });
    }
  }
}
