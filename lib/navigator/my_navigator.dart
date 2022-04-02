import 'package:flutter/material.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';

import 'package:url_launcher/url_launcher.dart';

import '../http/core/route_jump_listener.dart';
import '../util/app_util.dart';

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener(this.onJumpTo);
}

typedef OnJumpTo = Function(RouteStatus routeStatus, {Map? args});

typedef RouteChangeListener = Function(
    RouteStatusInfo current, RouteStatusInfo pre);

class MyNavigator extends _RouteJumpListener {
  MyNavigator._internal();

  factory MyNavigator() => _instance;

  static late final MyNavigator _instance = MyNavigator._internal();

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


