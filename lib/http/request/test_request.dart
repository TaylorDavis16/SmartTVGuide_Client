import 'package:smart_tv_guide/http/request/base_request.dart';

class TestRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.get;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'test4';
  }
}
