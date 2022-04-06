import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/pages/collection_tab_page.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';

class CollectionProgramPage extends CollectionTabPage {
  const CollectionProgramPage(data, context, {Key? key})
      : super(data, context, key: key);

  @override
  _CollectionProgramPageState createState() => _CollectionProgramPageState();
}

class _CollectionProgramPageState
    extends CollectionTabPageBaseState<CollectionProgramPage> {

  @override
  void initItems() {
    items = UserDao.getProgramCollection();
  }

  @override
  void refreshItems() {
    UserDao.saveCollection();
    super.refreshItems();
  }

  @override
  void openPage(String name) {
    logger.i(name);
    MyNavigator().onJumpTo(RouteStatus.programCollectionFolder, args: {
      'items': {'list': items[name], 'title': name}
    });
  }

  @override
  Future<void> createItem(String name) async {
    if (await ProgramDao.create(name)) {
      super.createItem(name);
    }
  }

  @override
  Future<void> deleteItem(String name) async {
    if (await ProgramDao.delete(name)) {
      List remove = items
          .remove(name)
          .where((program) => !UserDao.containsProgram(program))
          .toList();
      if (remove.isNotEmpty) {
        Map<String, String> noLongerExist = {};
        for (var program in remove) {
          noLongerExist[program.title] = program.channel;
        }
        ProgramDao.updateProgramNum(noLongerExist);
      }
      refreshItems();
    }
  }

  @override
  Future<void> updateItem(String oldName, String newName) async {
    if (await ProgramDao.update(oldName, newName)) {
      super.updateItem(oldName, newName);
    }
  }
}
