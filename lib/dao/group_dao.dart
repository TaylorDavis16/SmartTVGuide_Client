import 'package:smart_tv_guide/dao/user_dao.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/view_util.dart';

import '../http/core/requester.dart';
import '../http/request/group_request.dart';

class GroupDao {
  static retrieve() async {
    BaseRequest groupRequest = GroupRequest.getRequest(option: 'retrieve');
    return await Requester().fire(groupRequest);
  }

  static Future create(String name) async {
    BaseRequest request = GroupRequest.getRequest(
      option: 'create',
    ).add('name', name);
    return await Requester().fire(request);
  }

  static Future update(int gid, String newName) async {
    BaseRequest request = GroupRequest.getRequest(option: 'update')
        .add('gid', gid)
        .add('name', newName);
    return await Requester().fire(request);
  }

  static Future delete(int gid) async {
    BaseRequest request =
        GroupRequest.getRequest(option: 'delete').add('gid', gid);
    return await Requester().fire(request);
  }

  static Future<bool> quit(int gid) async {
    return requestSend(() async {
      BaseRequest request = GroupRequest.getRequest(
        option: "quit",
      ).add('gid', gid);
      var result = await Requester().fire(request);
      return result['code'] == 1;
    });
  }

  static Future join(
      int gid, int owner, String ownerName, String groupName) async {
    BaseRequest request = GroupRequest.getRequest(option: 'join')
        .add('gid', gid)
        .add("owner", owner)
        .add('ownerName', ownerName)
        .add("myName", UserDao.getUser().username!)
        .add('groupName', groupName)
        .add('uid', UserDao.getUser().id!);
    var result = await Requester().fire(request);
    showToast(result['feedback']);
  }

  static Future search(String name) async {
    BaseRequest request =
        GroupRequest().add('option', 'search').add('name', name).add('id', UserDao.hasLogin() ? UserDao.getUser().id! : -1);
    return await Requester().fire(request);
  }
}
