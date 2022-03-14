import 'package:flutter/material.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';
import 'package:smart_tv_guide/pages/channel_detail_page.dart';
import 'package:smart_tv_guide/pages/home_page.dart';
import 'package:smart_tv_guide/pages/hot_page.dart';
import 'package:smart_tv_guide/pages/login_page.dart';
import 'package:smart_tv_guide/pages/my_page.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/pages/register_page.dart';
import 'package:smart_tv_guide/pages/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../util/app_util.dart';

typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo pre);

///创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
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
  unknown,
  notice
}

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is HomePage || page.child is TabNavigator) {
    return RouteStatus.home;
  } else if (page.child is HotPage) {
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
  } else {
    return RouteStatus.unknown;
  }
}

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

class HiNavigator extends _RouteJumpListener {
  HiNavigator._internal();

  factory HiNavigator() => _instance;

  static late final HiNavigator _instance = HiNavigator._internal();

  RouteJumpListener? _routeJump;
  final List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;

  //首页底部tab
  RouteStatusInfo? _bottomTab;

  Future<bool> openH5(String url) async {
    var result = await canLaunch(url);
    if (result) {
      return await launch(url);
    } else {
      return Future.value(false);
    }
  }

  ///首页底部tab切换监听
  void onBottomTabChange(Widget page) {
    _bottomTab = RouteStatusInfo(getStatus(pageWrap(page)), page);
    _notify(_bottomTab);
  }

  ///注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  ///监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  ///通知路由页面变化
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo? current) {
    logger.d('current: $current');
    if (current?.page is TabNavigator && _bottomTab != null) {
      //如果打开的是首页，则明确到首页具体的tab
      current = _bottomTab!;
    }
    for (var listener in _listeners) {
      listener(current!, _current!);
    }
    _current = current;
  }
}

///抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener(this.onJumpTo);
}
