import 'package:flutter/material.dart';

import '../navigator/hi_navigator.dart';
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
    return Scaffold(
      appBar: appBar("title", "rightTitle", () => print('123')),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => HiNavigator().onJumpTo(RouteStatus.login),
              child: const Text('Login'),
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
