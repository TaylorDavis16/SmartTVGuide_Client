import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/core/request_error.dart';
import 'package:smart_tv_guide/http/request/api_request.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';
import 'package:smart_tv_guide/http/request/trending_request.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../http/core/requester.dart';
import '../http/request/collect_request.dart';
import '../http/request/home_request.dart';
import '../model/home_model.dart';

class ChannelDao {
  static apiData() async{
    try{
      ApiRequest request = ApiRequest();
      return await Requester().fire(request);
    } catch(e){
      logger.d(e);
    }
  }
  static Map apiMap() => Hive.box('home').get('api');
  static Future<HomeModel> homeData() async {
    HomeRequest request = HomeRequest();
    request.add('name', 'home');
    var result = await Requester().fire(request);
    if (result['code'] != 1) {
      throw RequestError(result['code'], result['message']);
    }
    return HomeModel.fromJson(result['model']);
  }

  static retrieve() async {
    BaseRequest channelRequest =
        CollectRequest.getRequest(option: 'retrieve', type: 'channel');
    return await Requester().fire(channelRequest);
  }

  static Future<bool> updateData(
      Map<String, bool> operations, String channel, int change) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: 'update', type: 'channel')
              .add('operations', json.encode(operations))
              .add('channel', channel)
              .add('change', change);
      var result = await Requester().fire(request);
      if (result['code'] == 1) {
        UserDao.updateChannelCollection(operations, channel);
        return true;
      }
      return false;
    });
  }

  static Future<bool> create(String name, {option = 'create'}) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: option, type: 'channel')
              .add('name', name);
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future<bool> update(String oldName, String newName) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: 'changeName', type: 'channel')
              .add('oldName', oldName)
              .add('newName', newName);
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future<bool> updateCollectNum(List noLongerExist) async {
    return requestSend(() async {
      BaseRequest request = CollectRequest()
          .add('option', 'updateCollectNum')
          .add('type', 'channel')
          .add("remove", json.encode(noLongerExist));
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static trendingData({force = false}) async {
    try {
      BaseRequest request = TrendingRequest().add('force', force);
      return await Requester().fire(request);
    } catch (e){
      logger.w(e);
    }

  }
  static Future<bool> delete(String name) => create(name, option: 'delete');
}
