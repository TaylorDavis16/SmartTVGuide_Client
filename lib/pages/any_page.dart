import 'package:flutter/material.dart';
import 'package:smart_tv_guide/widget/appbar.dart';

class AnyPage extends StatefulWidget {
  const AnyPage({Key? key}) : super(key: key);

  @override
  _AnyPageState createState() => _AnyPageState();
}

class _AnyPageState extends State<AnyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('any', 'rightTitle', (){}),
      body: Text('Any page'),
    );
  }
}
