import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/model/channel.dart';
import 'package:smart_tv_guide/navigator/tab_navigator.dart';
import 'package:smart_tv_guide/pages/any_page.dart';
import 'package:smart_tv_guide/pages/channel_detail_page.dart';
import 'package:smart_tv_guide/pages/login_page.dart';
import 'package:smart_tv_guide/pages/program_detail_page.dart';
import 'package:smart_tv_guide/pages/register_page.dart';
import 'package:smart_tv_guide/tools/shared_variables.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/color.dart';

import 'http/core/hi_error.dart';
import 'http/core/hi_net.dart';
import 'navigator/hi_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const AppEntry()));
}

class AppEntry extends StatefulWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  void changeTheme() {
    setState(() {
      Share.brightness = Share.brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
    });
  }

  final RouteDelegate _routeDelegate = RouteDelegate();

  Future<void> init() async {
    initLogger();
    await Hive.initFlutter();
    await Hive.openBox('login_detail');
    // Share.map['switch'] = changeTheme;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //进行初始化
      future: init(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //定义route
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(routerDelegate: _routeDelegate)
            : const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
        return MaterialApp(
          home: widget,
          theme: ThemeData(primarySwatch: white, brightness: Share.brightness),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposeLogger();
  }
}

class RouteDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  late final GlobalKey<NavigatorState> navigatorKey;
  RouteStatus _routeStatus = RouteStatus.home;

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    }
    return _routeStatus;
  }

  bool get hasLogin => UserDao.hasLogin();
  List<MaterialPage> pages = [];
  Channel? channel;
  Program? program;
  int initialTabPage = 0;

  //为Navigator设置一个key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  RouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    HiNavigator().registerRouteJump(
        RouteJumpListener((RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (_routeStatus == RouteStatus.home) {
        initialTabPage = args?['page'];
      } else if (_routeStatus == RouteStatus.channelDetail) {
        channel = args!['channel'];
      } else if (_routeStatus == RouteStatus.programDetail) {
        program = args!['program'];
      }
      notifyListeners();
    }));
    //设置网络错误拦截器
    HiNet().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        UserDao.clearLogin();
        //拉起登录
        HiNavigator().onJumpTo(RouteStatus.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, _routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      logger.wtf('存在');
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (_routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(TabNavigator(
        initialPage: initialTabPage,
      ));
    } else if (_routeStatus == RouteStatus.channelDetail) {
      page = pageWrap(ChannelDetail(channel!));
    } else if (_routeStatus == RouteStatus.programDetail) {
      page = pageWrap((ProgramDetail(program!)));
    } else if (_routeStatus == RouteStatus.registration) {
      page = pageWrap(const RegisterPage());
    } else if (_routeStatus == RouteStatus.notice) {
      page = pageWrap(const AnyPage());
    } else if (_routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }
    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    //通知路由发生变化
    HiNavigator().notify(tempPages, pages);
    pages = tempPages;
    return WillPopScope(
      //fix Android物理返回键，无法返回上一页问题@https://github.com/flutter/flutter/issues/66349
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          // if (route.settings is MaterialPage) {
          //   //登录页未登录返回拦截
          //   if ((route.settings as MaterialPage).child is LoginPage) {
          //     if (!hasLogin) {
          //       showWarnToast("请先登录");
          //       return false;
          //     }
          //   }
          // }
          //执行返回操作
          if (!route.didPop(result)) {
            return false;
          }
          if (pages.isNotEmpty) {
            var tempPages = [...pages];
            pages.removeLast();
            //通知路由发生变化
            HiNavigator().notify(pages, tempPages);
          }
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {}
}

class RoutePath {
  final String location;

  RoutePath.home() : location = "/";

  RoutePath.detail() : location = "/detail";
}
