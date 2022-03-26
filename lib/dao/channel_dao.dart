import 'package:smart_tv_guide/http/core/request_error.dart';
import '../http/core/requester.dart';
import '../http/request/home_request.dart';
import '../model/channel.dart';
import '../model/home_model.dart';

class ChannelDao {
  static Future<HomeModel> homeData() async {
    HomeRequest request = HomeRequest();
    request.add('name', 'home');
    var result = await Requester().fire(request);
    if (result['code'] != 1) {
      throw RequestError(result['code'], result['message']);
    }
    return HomeModel.fromJson(result['model']);
  }

  static Future<List<Channel>> getSwiper() async {
    HomeRequest request = HomeRequest();
    request.add('name', 'swiper');
    Map<String, dynamic> result = await Requester().fire(request);
    List<Channel> channels = <Channel>[];
    if (result['code'] != 1) {
      throw RequestError(result['code'], result['message']);
    }
    result['channels'].forEach((v) => channels.add(Channel.fromJson(v)));
    return channels;
  }
}
