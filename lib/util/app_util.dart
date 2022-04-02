import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

import '../http/core/route_jump_listener.dart';
import '../model/channel.dart';
import '../model/user.dart';
import '../navigator/my_navigator.dart';
import '../tools/shared_variables.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChannelAdapter());
  Hive.registerAdapter(ProgramAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox('login_detail');
  await Hive.openBox('home');
  // Hive.box('home').delete('channelMap');
}

class SimpleLogFilter extends LogFilter {
  final isProd = const bool.fromEnvironment('dart.vm.product');

  @override
  bool shouldLog(LogEvent event) {
    return !isProd;
  }
}

Logger get logger => _logger;

late Logger _logger;

void initLogger() {
  _logger = Logger(
    filter: SimpleLogFilter(),
    printer: PrettyPrinter(methodCount: 1),
  );
}

void disposeLogger() {
  _logger.d('logger out!');
  _logger.close();
}

Widget theme({required Widget child}) {
  return Theme(
      data: ThemeData(
        brightness: Share.brightness,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: child);
}

void gotoChannel(Channel channel) {
  logger.i('Go to ' + channel.displayName);
  MyNavigator().onJumpTo(RouteStatus.channelDetail, args: {"channel": channel});
}

void gotoProgram(Program program) {
  logger.i('Go to ' + program.title + ' of ' + program.channel);
  MyNavigator().onJumpTo(RouteStatus.programDetail, args: {"program": program});
}

void sortNames(List list){
  list.sort();
  int d = list.indexOf('Default');
  if (d != 0) {
    list.setRange(1, d + 1, list.getRange(0, d));
    list[0] = 'Default';
  }
}

Random _random = Random();

Random random() {
  return _random;
}

Future<bool> requestSend(Future<bool> Function() send) async {
  try {
    return await send();
  } catch (e) {
    logger.w(e);
    return false;
  }
}
