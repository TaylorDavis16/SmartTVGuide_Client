import 'package:flutter/material.dart';

class MyExpansionTile<T, E extends Widget> extends StatelessWidget {
  final List<T> origin;
  final String title;
  final String subtitle;
  final E Function(T e) toElement;

  const MyExpansionTile(
      {required this.origin,
      required this.title,
      required this.subtitle,
      required this.toElement,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      initiallyExpanded: true,
      collapsedBackgroundColor: Colors.blueGrey,
      backgroundColor: Colors.white,
      iconColor: Colors.blue,
      subtitle: Text(subtitle),
      // Contents
      children: origin.map(toElement).toList(),
    );
  }
}
