import '../db/hi_cache.dart';
import '../http/core/hi_net.dart';
import '../http/request/base_request.dart';
import '../http/request/login_request.dart';
import '../http/request/registration_request.dart';
import '../util/app_util.dart';

class LoginDao {
  static const boardingPass = "boarding-pass";

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
    logger.i(result);
    if (result['code'] == 1) {
      HiCache().setString(boardingPass, result['info']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache().get(boardingPass);
  }
}
