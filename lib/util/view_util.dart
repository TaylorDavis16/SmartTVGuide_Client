import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_tv_guide/model/channel.dart';

import 'app_util.dart';
///带缓存的image
Widget cachedImage(Channel? channel,
    {double? width, double? height, BoxFit? fit = BoxFit.contain}) {
  var wrap = Wrap(
    children: [const Icon(Icons.tv), Text(channel == null ? "Expired" : channel.displayName)],
  );
  if(channel == null) return wrap;
  return channel.imgURL == 'unknown'
      ? wrap
      : CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
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
      imageUrl: channel.imgURL);
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

List<Map<String, Object>> configList(int length) {
  return List.generate(
    length,
    (index) => {"id": index, "height": random().nextInt(150) + 50.5},
  );
}

///错误提示样式的toast
void showWarnToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

///普通提示样式的toast
void showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}

bottomMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
