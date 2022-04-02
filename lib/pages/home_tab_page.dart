import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/util/view_util.dart';

import '../model/channel.dart';
import '../util/app_util.dart';
import '../util/color.dart';

class HomeTabPage extends StatefulWidget {
  final List<String> channelNames;
  const HomeTabPage(this.channelNames, {Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  Map channelMap = Hive.box('home').get('channelMap');
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = configList(widget.channelNames.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    logger.i(':didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MasonryGridView.count(
      itemCount: widget.channelNames.length,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      // the number of columns
      crossAxisCount: 2,
      // vertical gap between two items
      mainAxisSpacing: 4,
      // horizontal gap between two items
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        // display each item with a card
        Channel channel = channelMap[widget.channelNames[index]]!;
        return Card(
          // Give each item a random background color
          color: randomColor(),
          key: ValueKey(_items[index]['id']),
          child: SizedBox(
            height: _items[index]['height'],
            child: InkWell(
              onTap: () => gotoChannel(channel),
              child: Center(
                child: cachedImage(channel.imgURL, channel.displayName),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
