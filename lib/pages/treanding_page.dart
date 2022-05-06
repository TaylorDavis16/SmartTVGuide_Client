import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/http/core/route_jump_listener.dart';
import 'package:smart_tv_guide/navigator/my_navigator.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/color.dart';

import '../dao/channel_dao.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> channels = [];

  @override
  initState() {
    loadData(force: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () =>
                  MyNavigator().onJumpTo(RouteStatus.programSearch),
              icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: loadData,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) => Card(
                    color: randomColor(),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () => gotoChannel(channels[index]),
                      leading: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(channels[index].displayName),
                      subtitle: Text('${channels[index].about}'),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData({force = false}) async {
    var searchBox = Hive.box('search');
    Map channelMap = Hive.box('home').get('channelMap');
    var result = await ChannelDao.trendingData(force: force);
    if (result != null) {
      if (result['code'] == 1 && (result['new'] || force)) {
        searchBox.put('channels', result['data']);
        channels = result['data'].map((id) => channelMap[id]).toList();
      }
    } else {
      if (channels.isEmpty && searchBox.get('channels') != null) {
        channels = searchBox.get('channels').map((id) => channelMap[id]).toList();
      }
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
