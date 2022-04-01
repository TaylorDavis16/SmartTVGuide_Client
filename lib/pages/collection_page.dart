import 'package:flutter/material.dart';
import 'package:smart_tv_guide/pages/collection_channel_page.dart';
import 'package:smart_tv_guide/pages/collection_program_page.dart';
class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> with AutomaticKeepAliveClientMixin{

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: TabBarView(children: [
            CollectionChannelPage(Icons.tv, context),
            CollectionProgramPage(Icons.star, context),
          ]),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

