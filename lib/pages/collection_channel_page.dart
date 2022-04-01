import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/pages/collection_tab_page_state.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../dao/user_dao.dart';

class CollectionChannelPage extends CollectionTabPage {
  const CollectionChannelPage(IconData data, BuildContext context, {Key? key}) : super(data, context, key: key);

  @override
  _CollectionChannelPageState createState() => _CollectionChannelPageState();
}

class _CollectionChannelPageState
    extends CollectionTabPageBaseState<CollectionChannelPage> {
  // late CollectionChannelModel _channelModel;

  @override
  void initItems() {
    items = UserDao.getChannelCollection();
  }

  @override
  void openPage(String name) {
    logger.i(name);
  }

  @override
  Future<void> createItem(String name) async{
    if(await ChannelDao.create(name)){
      super.createItem(name);
    }
  }

  @override
  Future<void> deleteItem(String name) async{
    if(await ChannelDao.delete(name)){
      List remove = items.remove(name).where((channel) => !UserDao.containsChannel(channel)).toList();
      if(remove.isNotEmpty){
        await ChannelDao.updateCollectNum(remove);
      }
      refreshItems();
    }
  }

  @override
  Future<void> updateItem(String oldName, String newName) async{
    if(await ChannelDao.update(oldName, newName)){
      super.updateItem(oldName, newName);
    }
  }

}
