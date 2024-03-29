import 'package:flutter/material.dart';
import 'package:smart_tv_guide/util/color.dart';

class MultiSelect extends StatefulWidget {
  final Map<String, bool> itemMap;
  final String name;
  final void Function(List)? sort;

  const MultiSelect(this.name, this.itemMap, {Key? key, this.sort}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  void _itemChange(String itemValue, bool newVal) {
    setState(() {
      widget.itemMap[itemValue] = newVal;
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, widget.itemMap);
  }

  List<Widget> _checkBoxListTile(){
    List<String> options = widget.itemMap.keys.toList();
    if(widget.sort != null){
      widget.sort!(options);
    }
    return options.map((option) => CheckboxListTile(
      value: widget.itemMap[option],
      title: Text(option),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (isChecked) =>
          _itemChange(option, isChecked!),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.lightBlueAccent,
      title: Text(widget.name),
      content: SingleChildScrollView(
        child: ListBody(
          children: _checkBoxListTile(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.black),),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

mixin MultiSelectSupport<T extends StatefulWidget> on State<T> {
  String get selectBoxName;

  void sort(List list){}

  Map<String, bool> fetch();

  void showMultiSelect() async {
    Map<String, bool> selectBoxOptions = fetch();
    final Map<String, bool>? results = await showDialog(
        context: context,
        builder: (BuildContext context) =>
            MultiSelect(selectBoxName, Map.from(selectBoxOptions), sort: sort,));
    // Update UI
    if (results != null) {
      Map<String, bool> changes = {};
      selectBoxOptions.forEach((key, value) {
        if (value != results[key]) {
          changes[key] = results[key]!;
        }
      });
      if (changes.isNotEmpty) {
        bool keep1 = selectBoxOptions.values.any((value) => value);
        bool keep2 = selectBoxOptions.keys.any((key) => results[key]!);
        int change = 0;
        if (!keep1 && keep2) {
          change = 1;
        }
        if (keep1 && !keep2) {
          change = -1;
        }
        updateDB(changes, change);
      }
    }
  }

  /// Never invoke by yourself
  Future<void> updateDB(Map<String, bool> changes, int change);
}
