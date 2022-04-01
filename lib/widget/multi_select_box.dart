import 'package:flutter/material.dart';
import 'package:smart_tv_guide/util/color.dart';

class MultiSelect extends StatefulWidget {
  final Map<String, bool> itemMap;
  final String name;

  const MultiSelect(this.name, this.itemMap, {Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primary,
      title: Text(widget.name),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.itemMap.entries
              .map((entry) => CheckboxListTile(
                    value: entry.value,
                    title: Text(entry.key),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) =>
                        _itemChange(entry.key, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
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

  Map<String, bool> fetch();

  void showMultiSelect() async {
    Map<String, bool> selectBoxOptions = fetch();
    final Map<String, bool>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(selectBoxName, Map.from(selectBoxOptions));
      },
    );
    // Update UI
    if (results != null) {
      Map<String, bool> changes = {};
      selectBoxOptions.forEach((key, value) {
        if (value != results[key]) {
          changes[key] = results[key]!;
        }
      });
      if(changes.isNotEmpty) {
        bool keep1 = selectBoxOptions.values.any((value) => value);
        bool keep2 = selectBoxOptions.keys.any((key) => results[key]!);
        int change = 0;
        if(!keep1 && keep2){
          change = 1;
        }
        if(keep1 && !keep2){
          change = -1;
        }
        updateDB(changes, change);
      }
    }
  }

  /// Never invoke by yourself
  Future<void> updateDB(Map<String, bool> changes, int change);
}
