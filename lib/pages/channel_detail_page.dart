import 'package:flutter/material.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

class ChannelDetail extends StatefulWidget {
  final Channel channel;
  const ChannelDetail(this.channel,{Key? key}) : super(key: key);

  @override
  _ChannelDetailState createState() => _ChannelDetailState();
}

class _ChannelDetailState extends State<ChannelDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(widget.channel.displayName, 'Something', () => {}),
      body: ListView(
        children: [
          Text(widget.channel.about),
          Text(widget.channel.id),
          Text(widget.channel.displayName),
          Text(widget.channel.url),
          Text(widget.channel.imgURL),
          Text(widget.channel.programs.length.toString()),
        ],
      )
    );
  }
}
