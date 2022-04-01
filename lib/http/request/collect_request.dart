import '../../dao/user_dao.dart';
import 'base_request.dart';

class CollectRequest extends BaseRequest {
  static BaseRequest getRequest(
          {required String option, required String type}) =>
      CollectRequest()
          .add('email', UserDao.getUser().email!)
          .add('option', option)
          .add('type', type);

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
    return "collect";
  }
}
