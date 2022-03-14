import 'package:logger/logger.dart';

import '../model/channel.dart';
import '../navigator/hi_navigator.dart';

class SimpleLogFilter extends LogFilter {
  final isProd = const bool.fromEnvironment('dart.vm.product');

  @override
  bool shouldLog(LogEvent event) {
    return !isProd;
  }
}

Logger get logger => _logger;

var _logger = Logger(
  filter: SimpleLogFilter(),
  printer: PrettyPrinter(methodCount: 1),
);

void gotoChannel(Channel channel) {
  logger.i('Go to ' + channel.displayName);
  HiNavigator().onJumpTo(RouteStatus.channelDetail, args: {"channel": channel});
}

void gotoProgram(Program program) {
  logger.i('Go to' + program.title + ' of ' + program.channel);
  HiNavigator().onJumpTo(RouteStatus.programDetail, args: {"program": program});
}
