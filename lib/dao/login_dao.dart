import 'package:smart_tv_guide/http/core/hi_error.dart';

import '../db/hi_cache.dart';
import '../http/core/hi_net.dart';
import '../http/request/base_request.dart';
import '../http/request/login_request.dart';
import '../http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

  LoginDao._internal();

  static login(String email, String password) {
    return _send(email, password);
  }

  static register(
      String username, String email, String password, String gender) {
    return _send(email, password, username: username, gender: gender);
  }

  static _send(String email, String password, {username, gender}) async {
    BaseRequest request;
    if (username == null) {
      request = LoginRequest();
      request.add("email", email).add("password", password);
    } else {
      request = RegistrationRequest();
      request
          .add("email", email)
          .add("password", password)
          .add("username", username)
          .add("gender", gender);
    }
    var result = await HiNet().fire(request);
    print(result);
    if (result['code'] == 1) {
      HiCache().setString(BOARDING_PASS, result['info']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache().get(BOARDING_PASS);
  }
}
