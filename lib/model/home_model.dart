import 'package:smart_tv_guide/model/channel.dart';

///解放生产力：在线json转dart https://www.devio.org/io/tools/json-to-dart/
class HomeModel {
  List<Channel> bannerList = [];
  List<Channel> channels = [];
  int maxSize = 0;

  HomeModel(this.bannerList, this.channels, this.maxSize);

  HomeModel.fromJson(Map<String, dynamic> json) {
    maxSize = json['maxSize'];
    if (json['bannerList'] != null) {
      json['bannerList'].forEach((v) {
        bannerList.add(Channel.fromJson(v));
      });
    }
    if (json['channels'] != null) {
      json['channels'].forEach((v) {
        channels.add(Channel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxSize'] = maxSize;
    data['bannerList'] = bannerList.map((v) => v.toJson()).toList();
    data['channels'] = channels.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    int bannerLength = bannerList.length, channelLength = channels.length;
    return 'HomeModel{bannerList: $bannerLength, channels: $channelLength, maxSize: $maxSize}';
  }
}
