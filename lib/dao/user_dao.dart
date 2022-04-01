import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/dao/channel_dao.dart';
import 'package:smart_tv_guide/dao/program_dao.dart';
import 'package:smart_tv_guide/http/request/check_code_request.dart';
import 'package:smart_tv_guide/model/user.dart';

import '../http/core/requester.dart';
import '../http/request/base_request.dart';
import '../http/request/login_request.dart';
import '../http/request/registration_request.dart';
import '../model/channel.dart';
import '../util/app_util.dart';
import '../util/view_util.dart';

class UserDao {
  static final _loginBox = Hive.box('login_detail');
  static const boardingPass = "boarding-pass";

  UserDao._internal();

  static login(String email, String password) async {
    BaseRequest request = LoginRequest();
    request.add("email", email).add("password", password);
    var result = await Requester().fire(request);
    if (result['code'] == 1) {
      showToast('Login Successful');
      await _loginBox.put(boardingPass, User.fromJson(result['user']));
      await retrieveCollectionData(email);
    }
    return result;
  }

  static retrieveCollectionData(String email) async {
    Map<String, Map> map = {};
    var retrieveChannel = await ChannelDao.retrieve();
    var retrieveProgram = await ProgramDao.retrieve();
    if (retrieveChannel['code'] == 1) {
      map['channel_collection'] = retrieveChannel['channel_collection'];
    }
    if (retrieveProgram['code'] == 1) {
      map['program_collection'] = retrieveProgram['program_collection'].map(
              (key, list) =>
              MapEntry(
                  key, list.map((value) => Program.fromJson(value)).toList()));
    }
    await _loginBox.put(email, map);
    logger.d(retrieveChannel);
    logger.d(retrieveProgram);
    logger.d(map);
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
    _loginBox.delete(getUser().email);
    _loginBox.delete(boardingPass);
  }

  static User getUser() {
    return _loginBox.get(boardingPass);
  }

  static Map getChannelCollection() =>
      _loginBox.get(getUser().email)['channel_collection'];

  static Map getProgramCollection() =>
      _loginBox.get(getUser().email)['program_collection'];

  static void updateChannelCollection(Map<String, bool> operations,
      String channel) {
    Map collection = getChannelCollection();
    operations.forEach((groupName, like) {
      like
          ? collection[groupName]!.add(channel)
          : collection[groupName]!.remove(channel);
    });
  }

  static void updateProgramCollection(Map<String, bool> operations,
      Program program) {
    Map collection = getProgramCollection();
    operations.forEach((groupName, like) {
      like
          ? collection[groupName]!.add(program)
          : collection[groupName]!.remove(program);
    });
  }

  static bool containsChannel(String channel) =>
      getChannelCollection().values.any((list) => list.contains(channel));

  static bool containsProgram(Program program) =>
      getProgramCollection().values.any((list) => list.contains(program));

  static void updateAllChannelCollection(Map<String, List<String>> map) =>
      _loginBox.get(getUser().email)['channel_collection'] = map;

  static void updateAllProgramCollection(Map<String, List<Program>> map) =>
      _loginBox.get(getUser().email)['program_collection'] = map;
}
