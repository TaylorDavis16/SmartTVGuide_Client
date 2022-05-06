import 'package:flutter/material.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';
import 'package:smart_tv_guide/pages/channel_detail_page.dart';
import 'package:smart_tv_guide/pages/collection_channel_folder_page.dart';
import 'package:smart_tv_guide/pages/collection_program_folder_page.dart';
import 'package:smart_tv_guide/pages/homepage.dart';
import 'package:smart_tv_guide/pages/hot_page.dart';
import 'package:smart_tv_guide/pages/login_page.dart';
import 'package:smart_tv_guide/pages/my_page.dart';
import 'package:smart_tv_guide/pages/group_search_page.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/pages/program_search_page.dart';
import 'package:smart_tv_guide/pages/register_page.dart';

import '../../pages/collection_page.dart';
import '../../pages/group_manage_page.dart';
import '../../pages/hot_tab_collection_page.dart';
import '../../pages/treanding_page.dart';


///路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);

  @override
  String toString() {
    return 'RouteStatusInfo{routeStatus: $routeStatus, page: $page}';
  }
}

///创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

Map _statusMap = {
  TabNavigator: RouteStatus.tabNavigator,
  HomePage: RouteStatus.tabNavigator,
  HotPage: RouteStatus.tabNavigator,
  TrendingPage: RouteStatus.tabNavigator,
  MinePage: RouteStatus.tabNavigator,
  ProgramSearchPage: RouteStatus.programSearch,
  ChannelDetail: RouteStatus.channelDetail,
  ProgramDetail: RouteStatus.programDetail,
  HotTabCollectionPage: RouteStatus.hotCollectionTab,
  RegisterPage: RouteStatus.registration,
  LoginPage: RouteStatus.login,
  CollectionPage: RouteStatus.collection,
  CollectionChannelFolderPage: RouteStatus.channelCollectionFolder,
  CollectionProgramFolderPage: RouteStatus.programCollectionFolder,
  GroupSearchPage: RouteStatus.groupSearch,
  GroupManagePage : RouteStatus.groupManagement,
};

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) => _statusMap[page.child.runtimeType] ?? RouteStatus.unknown;

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

///自定义路由封装，路由状态
enum RouteStatus {
  tabNavigator,
  programSearch,
  login,
  registration,
  groupSearch,
  groupManagement,
  groupDetail,
  channelDetail,
  programDetail,
  collection,
  hotCollectionTab,
  channelCollectionFolder,
  programCollectionFolder,
  peopleSearch,
  unknown,
}


