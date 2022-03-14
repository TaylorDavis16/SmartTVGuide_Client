import 'dart:developer';

import 'package:flutter/material.dart';

class DropdownBox extends StatefulWidget {
  final List<String> list;
  final String selected;

  const DropdownBox(this.list, this.selected, {Key? key}) : super(key: key);

  @override
  _DropdownBoxState createState() => _DropdownBoxState();
}

class _DropdownBoxState extends State<DropdownBox> {
  late String selected;
  bool initiated = false;

  @override
  Widget build(BuildContext context) {
    if (!initiated) {
      selected = widget.selected;
      initiated = true;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
          color: const Color.fromRGBO(210, 207, 207, 0.8),
          border: Border.all(color: Colors.black38, width: 3),
          borderRadius: BorderRadius.circular(60),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.57),
              blurRadius: 5,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: DropdownButton<String>(
          value: selected,
          items: widget.list
              .map((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) {
            log("You have selected $value");
            setState(() {
              selected = value!;
            });
          },
          icon: const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(Icons.arrow_circle_down_sharp)),
          iconEnabledColor: Colors.white,
          style: const TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          dropdownColor: const Color.fromRGBO(210, 207, 207, 0.8),
          underline: Container(),
          isExpanded: true,
        ),
      ),
    );
  }
}
