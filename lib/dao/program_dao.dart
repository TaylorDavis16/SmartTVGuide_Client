import 'dart:convert';

import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';
import 'package:smart_tv_guide/model/hot_program_model.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../http/core/request_error.dart';
import '../http/core/requester.dart';
import '../http/request/collect_request.dart';
import '../http/request/hot_request.dart';
import '../model/channel.dart';

class ProgramDao {
  static Future<HotProgramModel> hotProgramData(int pageIndex, int pageSize) async {
    BaseRequest request = HotRequest()
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize)
        .add('email', UserDao.getUser().email!);
    var result = await Requester().fire(request);

    if (result['code'] != 1) {
      throw RequestError(result['code'], result['message']);
    }
    return HotProgramModel.fromJson(result['model']);
  }


  static retrieve() async {
    BaseRequest programRequest =
        CollectRequest.getRequest(option: 'retrieve', type: 'program');
    return await Requester().fire(programRequest);
  }

  static Future<bool> updateData(
      Map<String, bool> operations, Program program, int change) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: 'update', type: 'program')
              .add('operations', json.encode(operations))
              .add('program', json.encode(program))
              .add('change', change);
      var result = await Requester().fire(request);
      if (result['code'] == 1) {
        UserDao.updateProgramCollection(operations, program);
        return true;
      }
      return false;
    });
  }

  static Future<bool> create(String name, {option = 'create'}) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: option, type: 'program')
              .add('name', name);
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future<bool> update(String oldName, String newName) async {
    return requestSend(() async {
      BaseRequest request =
          CollectRequest.getRequest(option: 'changeName', type: 'program')
              .add('oldName', oldName)
              .add('newName', newName);
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future<bool> updateProgramNum(Map noLongerExist) async {
    return requestSend(() async {
      BaseRequest request = CollectRequest()
          .add('option', 'updateCollectNum')
          .add('type', 'program')
          .add("remove", json.encode(noLongerExist));
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future<bool> delete(String name) => create(name, option: 'delete');
}
