import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/http/core/route_jump_listener.dart';
import 'package:smart_tv_guide/navigator/my_navigator.dart';
import 'package:smart_tv_guide/pages/collection_tab_page.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../dao/user_dao.dart';

class CollectionChannelPage extends CollectionTabPage {
  const CollectionChannelPage(IconData data, BuildContext context, {Key? key})
      : super(data, context, key: key);

  @override
  _CollectionChannelPageState createState() => _CollectionChannelPageState();
}

class _CollectionChannelPageState
    extends CollectionTabPageBaseState<CollectionChannelPage> {

  @override
  void initItems() {
    items = UserDao.getChannelCollection();
  }

  @override
  void refreshItems() {
    UserDao.saveCollection();
    super.refreshItems();
  }

  @override
  void openPage(String name) {
    logger.i(name);
    MyNavigator().onJumpTo(RouteStatus.channelCollectionFolder, args: {
      'items': {'list': items[name], 'title': name}
    });
  }

  @override
  Future<void> createItem(String name) async {
    if (await ChannelDao.create(name)) {
      super.createItem(name);
    }
  }

  @override
  Future<void> deleteItem(String name) async {
    if (await ChannelDao.delete(name)) {
      List noLongerExist = items
          .remove(name)
          .where((channel) => !UserDao.containsChannel(channel))
          .toList();
      if (noLongerExist.isNotEmpty) {
        ChannelDao.updateCollectNum(noLongerExist);
      }
      refreshItems();
    }
  }

  @override
  Future<void> updateItem(String oldName, String newName) async {
    if (await ChannelDao.update(oldName, newName)) {
      super.updateItem(oldName, newName);
    }
  }
}
