import 'package:flutter/foundation.dart';

import '../model/channel.dart';
import '../navigator/hi_navigator.dart';

void gotoChannel(Channel channel) {
  if (kDebugMode) {
    print('Go to ' + channel.displayName);
  }
  HiNavigator().onJumpTo(RouteStatus.channelDetail, args: {"channel": channel});
}

void gotoProgram(Program program) {
  if (kDebugMode) {
    print('Go to' + program.title + ' of ' + program.channel);
  }
  HiNavigator().onJumpTo(RouteStatus.programDetail, args: {"program": program});
}
