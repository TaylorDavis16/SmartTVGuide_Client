import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/dao/group_dao.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/request/check_code_request.dart';
import 'package:smart_tv_guide/model/collection_model.dart';
import 'package:smart_tv_guide/model/user.dart';

import '../http/core/requester.dart';
import '../http/core/route_jump_listener.dart';
import '../http/request/base_request.dart';
import '../http/request/login_request.dart';
import '../http/request/registration_request.dart';
import '../model/channel.dart';
import '../model/group.dart';
import '../navigator/my_navigator.dart';
import '../util/app_util.dart';
import '../util/view_util.dart';

class UserDao {
  static final _loginBox = Hive.box('login_detail');
  static const boardingPass = "boarding-pass";

  UserDao._internal();

  static ensureLogin(Function() doStuff){
    if (hasLogin()) {
      doStuff();
    } else {
      showWarnToast("Please login first");
      MyNavigator().onJumpTo(RouteStatus.login);
    }
  }

  static login(String email, String password) async {
    BaseRequest request = LoginRequest();
    request.add("email", email).add("password", password);
    var result = await Requester().fire(request);
    if (result['code'] == 1) {
      showToast('Login Successful');
      _loginBox.put(boardingPass, User.fromJson(result['user']));
      retrieveCollectionData();
      retrieveGroupData();
    }
    return result;
  }

  static retrieveCollectionData() async {
    Map<String, Map> map = {};
    var retrieveChannel = await ChannelDao.retrieve();
    var retrieveProgram = await ProgramDao.retrieve();
    if (retrieveChannel['code'] == 1) {
      map['channel_collection'] = retrieveChannel['channel_collection'];
    }
    if (retrieveProgram['code'] == 1) {
      map['program_collection'] = retrieveProgram['program_collection'];
    }
    CollectionModel model = CollectionModel.fromJson(map);
    _loginBox.put('collection', model);
    logger.d(map);
  }

  static Future retrieveGroupData() async {
    var result = await GroupDao.retrieve();
    if (result['code'] == 1) {
      logger.i(result['groups']);
      result['groups'].forEach((key, group) => result['groups'].update(key, (group) => Group.fromJson(group)));
      _loginBox.put('group', result['groups']);
    }
  }
  
  

  static register(String username, String email, String password,
      String gender) async {
    BaseRequest request = RegistrationRequest();
    request
        .add("email", email)
        .add("password", password)
        .add("username", username)
        .add("gender", gender);
    return await Requester().fire(request);
  }

  static sendCheckCode(String email, String username) async {
    BaseRequest request = CheckCodeRequest();
    request.add("email", email).add('username', username);
    return await Requester().fire(request);
  }

  static bool hasLogin() {
    return _loginBox.containsKey(boardingPass);
  }

  static void clearLogin() {
    showToast('Log out Successful');
    _loginBox.delete('collection');
    _loginBox.delete('groups');
    _loginBox.delete(boardingPass);
  }

  static User getUser() {
    return _loginBox.get(boardingPass);
  }

  static Map getChannelCollection() =>
      _loginBox.get('collection').channelCollection;

  static Map getProgramCollection() =>
      _loginBox.get('collection').programCollection;

  static Map getGroupData() =>  _loginBox.get('group');

  static void updateChannelCollection(Map<String, bool> operations,
      String channel) {
    Map collection = getChannelCollection();
    operations.forEach((groupName, like) {
      like
          ? collection[groupName]!.add(channel)
          : collection[groupName]!.remove(channel);
    });
    saveCollection();
  }

  static void updateProgramCollection(Map<String, bool> operations,
      Program program) {
    Map collection = getProgramCollection();
    operations.forEach((groupName, like) {
      like
          ? collection[groupName]!.add(program)
          : collection[groupName]!.remove(program);
    });
    saveCollection();
  }

  static void saveCollection(){
    _loginBox.get('collection').save();
  }

  static void saveGroups(Map newGroups){
    _loginBox.put('group', newGroups);
  }

  static bool containsChannel(String channel) =>
      getChannelCollection().values.any((list) => list.contains(channel));

  static bool containsProgram(Program program) =>
      getProgramCollection().values.any((list) => list.contains(program));

}
