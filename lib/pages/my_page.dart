import 'dart:core';

import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';

import '../http/core/route_jump_listener.dart';
import '../navigator/my_navigator.dart';
import '../tools/shared_variables.dart';
import '../widget/appbar.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    bool hasLogin = UserDao.hasLogin();
    String text = hasLogin ? 'Logout' : 'Login';
    return Scaffold(
      appBar: appBar("Mine"),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                if (hasLogin) {
                  UserDao.clearLogin();
                  MyNavigator().onJumpTo(RouteStatus.tabNavigator, args: {"page": 0});
                } else {
                  MyNavigator().onJumpTo(RouteStatus.login);
                }
              },
              child: Text(text),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            ElevatedButton(
              onPressed: Share.map['switch'],
              child: const Text('Switch'),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            if (hasLogin)
              ElevatedButton(
                onPressed: () => MyNavigator().onJumpTo(RouteStatus.collection),
                child: const Text('My Collection'),
              ),
            if (hasLogin)
              ElevatedButton(
                onPressed: () => MyNavigator().onJumpTo(RouteStatus.groupSearch),
                child: const Text('Groups'),
              ),
          ],
        ),
      ),
    );
  }
}
