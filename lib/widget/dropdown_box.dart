
import 'package:flutter/material.dart';

class DropdownController{
  List<String> list;
  String selected;

  DropdownController(this.list, this.selected);
}

class DropdownBox extends StatefulWidget {
  final DropdownController? dropdownController;

  const DropdownBox(this.dropdownController, {Key? key}) : super(key: key);

  @override
  _DropdownBoxState createState() => _DropdownBoxState();
}

class _DropdownBoxState extends State<DropdownBox> {
  late List<String> _list;

  @override
  Widget build(BuildContext context) {
    _list = widget.dropdownController!.list;
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
          value: widget.dropdownController?.selected,
          items: _list
              .map((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              widget.dropdownController?.selected = value!;
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
