import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/core/base_state.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/format_util.dart';
import 'package:smart_tv_guide/widget/appbar.dart';
import 'package:smart_tv_guide/widget/multi_select_box.dart';

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
  Map apiData = ChannelDao.apiMap();

  _ChannelDetailState() : super(needScrollController: true);

  @override
  Future<void> refresh() async {
    colors = List.generate(_items.length, (_) => randomColor());
    loadData();
  }

  @override
  void addScrollListener() {
    scrollController?.addListener(() {
      if (scrollController?.position.extentAfter == 0 && !calm) {
        bottomMessage(context, 'You have reached the end');
        calm = true;
        Future.delayed(const Duration(seconds: 5)).then((_) => calm = false);
      }
    });
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
    UserDao.ensureLogin(() => showMultiSelect());
  }

  @override
  get contentChild {
    List<Program> programs = widget.channel.programs;
    bool hasInfo = apiData[widget.channel.id] != null;
    var website = hasInfo ? apiData[widget.channel.id]['website'] : null;
    return Scaffold(
        appBar: appBar(widget.channel.displayName,
            rightTitle: marked ? 'Remove' : 'Add',
            rightButtonClick: () => _like(),
            icon: marked ? Icons.favorite : Icons.favorite_border_outlined),
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            _sliverBar(
                'Channel Information',
                Icons.arrow_circle_up,
                () => scrollController!.animateTo(
                    scrollController!.position.minScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease)),
            if(hasInfo)
            SliverGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 10,
              children: [
                _detail('Name: ${widget.channel.displayName}'),
                if (apiData[widget.channel.id]['native_name'] != null)
                  _detail(
                      'Native Name: ${apiData[widget.channel.id]['native_name']}'),
                if (apiData[widget.channel.id]['country'] != null)
                  _detail('Country: ${apiData[widget.channel.id]['country']}'),
                _detail('Program Numbers: ${widget.channel.programs.length}'),
                _detail('About: ${widget.channel.about}'),
                if (apiData[widget.channel.id]['categories'].isNotEmpty)
                  _detail(
                      'Categories: ${apiData[widget.channel.id]['categories'].toString()}'),
                if (apiData[widget.channel.id]['broadcast_area'].isNotEmpty)
                  _detail(
                      'Broadcast Area: ${apiData[widget.channel.id]['broadcast_area'].toString()}'),
                if (apiData[widget.channel.id]['languages'].isNotEmpty)
                  _detail(
                      'Languages: ${apiData[widget.channel.id]['languages'].toString()}'),
              ],
            ),
            if(hasInfo)
            SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 3,
              children: [
                const Text(''),
                if (website != null)
                  ElevatedButton(
                    onPressed: () async => await MyNavigator().openH5(website),
                    child: const Text(
                      'Open Website',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                const Text(''),
              ],
            ),
            _sliverBar(
                'Programs',
                Icons.arrow_circle_down,
                () => scrollController!.animateTo(
                    scrollController!.position.maxScrollExtent,
                    duration: const Duration(seconds: 1),
                    curve: Curves.ease)),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 2,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  color: colors[index],
                  key: ValueKey(_items[index]['id']),
                  child: SizedBox(
                    height: _items[index]['height'],
                    child: InkWell(
                      onTap: () => gotoProgram(programs[index]),
                      child: Center(
                        child: Wrap(
                          children: [
                            Text('${programs[index].title}\n'),
                            Text(
                                '${dateHourAndMinute(programs[index].start!)} - ${dateHourAndMinute(programs[index].stop!)}')
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: _items.length),
            ),
          ],
        ));
  }

  _sliverBar(String text, IconData icon, void Function()? onPressed) =>
      SliverAppBar(
        actions: [IconButton(onPressed: onPressed, icon: Icon(icon))],
        leading: const Text(''),
        pinned: true,
        backgroundColor: Colors.green,
        expandedHeight: 70.0,
        elevation: 1,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          centerTitle: true,
        ),
      );

  _detail(String data) => Card(
        color: Colors.blue[200],
        child: Text(data),
      );

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
    var success =
        await ChannelDao.updateData(changes, widget.channel.id, change);
    _refresh(success);
  }

  _refresh(bool refresh) {
    if (refresh) {
      setState(() {
        marked = UserDao.containsChannel(widget.channel.id);
      });
    }
  }
}
