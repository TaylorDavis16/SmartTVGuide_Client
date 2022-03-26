import 'package:smart_tv_guide/model/channel.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class HomeModel {
  Map<String, Channel> channelMap = {};

  HomeModel(this.channelMap);

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['channelMap'] != null) {
      json['channelMap'].forEach((k, v) => channelMap[k] = Channel.fromJson(v));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    channelMap.forEach((key, value) => data[key] = value.toJson());
    return data;
  }

  @override
  String toString() {
    return 'HomeModel{bannerList: ${channelMap.length}}';
  }
}
