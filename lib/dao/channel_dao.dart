import 'package:smart_tv_guide/http/core/hi_error.dart';
import '../http/core/hi_net.dart';
import '../http/request/channel_request.dart';
import '../model/channel.dart';
import '../model/home_model.dart';

class ChannelDao {
  static Future<HomeModel> homeData(
      {bool swiper = false, int pageIndex = 1, int pageSize = 10}) async {
    HomeRequest request = HomeRequest();
    request
        .add('name', 'home')
        .add('swiper', swiper)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await HiNet().fire(request);
    if (result['code'] != 1) {
      throw HiNetError(result['code'], result['message']);
    }
    return HomeModel.fromJson(result['model']);
  }

  static Future<List<Channel>> getAll() async {
    HomeRequest request = HomeRequest();
    request.add('name', 'all');
    Map<String, dynamic> result = await HiNet().fire(request);
    List<Channel> channels = <Channel>[];
    if (result['code'] != 1) {
      throw HiNetError(result['code'], result['message']);
    }
    result['channels'].forEach((v) => channels.add(Channel.fromJson(v)));
    return channels;
  }

  static Future<List<Channel>> getSwiper() async {
    HomeRequest request = HomeRequest();
    request.add('name', 'swiper');
    Map<String, dynamic> result = await HiNet().fire(request);
    List<Channel> channels = <Channel>[];
    if (result['code'] != 1) {
      throw HiNetError(result['code'], result['message']);
    }
    result['channels'].forEach((v) => channels.add(Channel.fromJson(v)));
    return channels;
  }
}
