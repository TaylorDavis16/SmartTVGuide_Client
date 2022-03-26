import 'package:flutter/material.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/util/app_util.dart';

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
    String text = hasLogin ? 'Logout':'Login';
    return Scaffold(
      appBar: appBar("title", "rightTitle", () => logger.i('123')),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                if(hasLogin){
                  UserDao.clearLogin();
                  setState(() {
                  });
                }else{
                  MyNavigator().onJumpTo(RouteStatus.login);
                }
              },
              child: Text(text),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            ElevatedButton(
              onPressed: Share.map['switch'],
              child: const Text('Switch'),
            )
          ],
        ),
      ),
    );
  }
}
