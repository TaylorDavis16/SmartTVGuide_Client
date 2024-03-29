import 'package:flutter/material.dart';
import 'package:smart_tv_guide/util/app_util.dart';

///自定义顶部appBar
appBar(String title,
    {String? rightTitle,
    VoidCallback? rightButtonClick,
    IconData? icon,
    bool leading = false,
    centerTitle = false}) {
  return AppBar(
    //让title居左
    centerTitle: centerTitle,
    titleSpacing: 0,
    leading: leading ? const BackButton() : null,
    title: Text(
      title,
      style: const TextStyle(fontSize: 18),
    ),
    actions: [
      theme(
          child: InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.center,
          child: Wrap(
            children: [
              Icon(
                icon,
                color: Colors.red,
              ),
              if (rightTitle != null)
                Text(
                  rightTitle,
                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                )
            ],
          ),
        ),
      ))
    ],
  );
}
