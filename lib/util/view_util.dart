import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import 'format_util.dart';

///带缓存的image
Widget cachedImage(String url, String alternative,
    {double? width, double? height}) {
  var wrap = Wrap(
    children: [const Icon(Icons.tv), Text(alternative)],
  );
  try {
    return url == 'unknown'
        ? wrap
        : CachedNetworkImage(
            height: height,
            width: width,
            fit: BoxFit.cover,
            placeholder: (
              BuildContext context,
              String url,
            ) =>
                Container(color: Colors.grey[200]),
            errorWidget: (
              BuildContext context,
              String url,
              dynamic error,
            ) =>
                wrap,
            imageUrl: url);
  } on SocketException catch (e) {
    logger.e('Fail to load image!' + e.message);
    return wrap;
  }
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

///修改状态栏
// void changeStatusBar(
//     {color = Colors.white, StatusStyle statusStyle = StatusStyle.DARK_CONTENT}) {
//   //沉浸式状态栏样式
//   FlutterStatusbarManager.setColor(color, animated: false);
//   FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT
//       ? StatusBarStyle.DARK_CONTENT
//       : StatusBarStyle.LIGHT_CONTENT);
// }

///带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = const TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(
      ' $text',
      style: style,
    )
  ];
}

///border线
borderLine(BuildContext context, {bottom = true, top = false}) {
  BorderSide borderSide = BorderSide(width: 0.5, color: Colors.grey[200]!);
  return Border(
    bottom: bottom ? borderSide : BorderSide.none,
    top: top ? borderSide : BorderSide.none,
  );
}

///间距
SizedBox hiSpace({double height = 1, double width = 1}) {
  return SizedBox(height: height, width: width);
}

///底部阴影
BoxDecoration bottomBoxShadow() {
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: const Offset(0, 5), //xy轴偏移
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1 //阴影扩散程度
        )
  ]);
}

//加载圈圈
Offstage offstage(bool condition) {
  // debug(window.physicalSize.width);
  return Offstage(
    offstage: condition,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            color: Colors.black,
            strokeWidth: 2,
          ),
        ),
        Text(' loading...'),
      ],
    ),
  );
}

List<Map<String, Object>> configList(int length, Random random) {
  return List.generate(
    length,
    (index) => {"id": index, "height": random.nextInt(150) + 50.5},
  );
}
