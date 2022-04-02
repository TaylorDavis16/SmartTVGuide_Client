import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/pages/channel_detail_page.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

import '../model/channel.dart';
import '../navigator/my_navigator.dart';
import '../util/app_util.dart';
import '../util/color.dart';
import '../util/view_util.dart';

class CollectionChannelFolderPage extends StatefulWidget {
  final Map items;
  const CollectionChannelFolderPage(this.items, {Key? key}) : super(key: key);

  @override
  State<CollectionChannelFolderPage> createState() => _CollectionChannelFolderPageState();
}

class _CollectionChannelFolderPageState extends State<CollectionChannelFolderPage> {
  late List channelNameList = widget.items['list'];
  Map channelMap = Hive.box('home').get('channelMap');
  late final List<Map<String, dynamic>> _items = configList(channelNameList.length);

  @override
  void initState() {
    super.initState();
    MyNavigator().addListener((current, pre) {
      if(widget == current.page && pre.page is ChannelDetail){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.items['title']),
      body: MasonryGridView.count(
        itemCount: channelNameList.length,
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
          Channel channel = channelMap[channelNameList[index]]!;
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
      ),
    );
  }
}
