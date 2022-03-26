import 'package:hive_flutter/adapters.dart';
import 'package:smart_tv_guide/http/request/check_code_request.dart';
import 'package:smart_tv_guide/model/user.dart';

import '../http/core/requester.dart';
import '../http/request/base_request.dart';
import '../http/request/login_request.dart';
import '../http/request/registration_request.dart';
import '../util/app_util.dart';

class UserDao {
  static final _loginBox = Hive.box('login_detail');
  static const boardingPass = "boarding-pass";

  UserDao._internal();

  static login(String email, String password) async {
    BaseRequest request = LoginRequest();
    request.add("email", email).add("password", password);
    var result = await Requester().fire(request);
    logger.i(result);
    if (result['code'] == 1) {
      await _loginBox.put(boardingPass, result['user']);
    }
    return result;
  }

  static register(
      String username, String email, String password, String gender) async {
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
    _loginBox.delete(boardingPass);
  }

  static User getUser() {
    return _loginBox.get(boardingPass);
  }
}
