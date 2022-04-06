import '../../dao/user_dao.dart';
import 'base_request.dart';

class GroupRequest extends BaseRequest {
  static BaseRequest getRequest(
          {required String option}) =>
      GroupRequest()
          .add('email', UserDao.getUser().email!)
          .add('option', option);

  @override
  HttpMethod httpMethod() {
    return HttpMethod.post;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "group";
  }
}
