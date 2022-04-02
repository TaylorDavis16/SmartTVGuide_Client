import 'package:flutter/material.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';
import 'package:smart_tv_guide/pages/channel_detail_page.dart';
import 'package:smart_tv_guide/pages/collection_channel_folder_page.dart';
import 'package:smart_tv_guide/pages/collection_program_folder_page.dart';
import 'package:smart_tv_guide/pages/home_tab_page.dart';
import 'package:smart_tv_guide/pages/homepage.dart';
import 'package:smart_tv_guide/pages/login_page.dart';
import 'package:smart_tv_guide/pages/my_page.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/pages/register_page.dart';
import 'package:smart_tv_guide/pages/search_page.dart';

import '../../pages/collection_page.dart';

typedef OnJumpTo = Function(RouteStatus routeStatus, {Map? args});

typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo pre);

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

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is HomeTabPage || page.child is TabNavigator) {
    return RouteStatus.home;
  } else if (page.child is HomePage) {
    return RouteStatus.hot;
  } else if (page.child is SearchPage) {
    return RouteStatus.search;
  } else if (page.child is ChannelDetail) {
    return RouteStatus.channelDetail;
  } else if (page.child is ProgramDetail) {
    return RouteStatus.programDetail;
  } else if (page.child is MinePage) {
    return RouteStatus.mine;
  } else if (page.child is RegisterPage) {
    return RouteStatus.registration;
  } else if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is CollectionPage) {
    return RouteStatus.collection;
  } else if (page.child is CollectionChannelFolderPage) {
    return RouteStatus.channelCollectionFolder;
  } else if (page.child is CollectionProgramFolderPage) {
    return RouteStatus.programCollectionFolder;
  } else {
    return RouteStatus.unknown;
  }
}

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
  home,
  hot,
  search,
  mine,
  login,
  registration,
  channelDetail,
  programDetail,
  collection,
  channelCollectionFolder,
  programCollectionFolder,
  unknown,
}

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener(this.onJumpTo);
}
