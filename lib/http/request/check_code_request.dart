import 'base_request.dart';

class CheckCodeRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.post;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'checkCode';
  }
}
