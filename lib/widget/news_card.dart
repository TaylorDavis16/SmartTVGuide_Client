import 'package:flutter/material.dart';

import '../http/core/route_jump_listener.dart';
import '../model/channel.dart';
import '../navigator/my_navigator.dart';
import '../util/view_util.dart';

///视频卡片
class NewsCard extends StatelessWidget {
  final Channel channel;

  const NewsCard(this.channel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          MyNavigator()
              .onJumpTo(RouteStatus.channelDetail, args: {"channel": channel});
        },
        child: SizedBox(
          height: 160,
          child: Card(
            //取消卡片默认边距
            margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_itemImage(context), _infoText()],
              ),
            ),
          ),
        ));
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(channel.imgURL, channel.displayName,
            width: size.width / 2 - 10, height: 120),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
            decoration: const BoxDecoration(
                //渐变
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconText(Icons.ondemand_video, channel.displayName),
                _iconText(Icons.favorite_border, channel.id),
              ],
            ),
          ),
        )
      ],
    );
  }

  _iconText(IconData iconData, String message) {
    return Row(
      children: [
        Icon(iconData, color: Colors.white, size: 12),
        Flexible(
            child: Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(message,
                    style: const TextStyle(color: Colors.white, fontSize: 10))))
      ],
    );
  }

  _infoText() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            channel.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          //作者
        ],
      ),
    ));
  }
}
