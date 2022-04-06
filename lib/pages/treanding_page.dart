import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/http/core/route_jump_listener.dart';
import 'package:smart_tv_guide/navigator/my_navigator.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/widget/loading_container.dart';

import '../dao/channel_dao.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> with AutomaticKeepAliveClientMixin{
  List<dynamic> channels = [];
  bool _isLoading = true;

  @override
  initState() {
    loadData();
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
          child: LoadingContainer(
            isLoading: _isLoading,
            child: Column(
              children: [Expanded(
                child: ListView.builder(
                  itemCount: channels.length,
                  itemBuilder: (context, index) => Card(
                    color: Colors.blue[100],
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () => gotoChannel(channels[index]),
                      leading: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(channels[index].displayName),
                      subtitle:
                      Text('${channels[index].about}'),
                    ),
                  ),
                ),
              )],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async{
    var searchBox = Hive.box('search');
    Map channelMap = Hive.box('home').get('channelMap');
    var result = await ChannelDao.trendingData();
    if(result['code'] == 1) {
      if(result['new']){
        searchBox.put('channels', result['data']);
      }
      channels = searchBox.get('channels').map((id) => channelMap[id]).toList();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
