import 'base_request.dart';

class ApiRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.get;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  Map<String, dynamic> get header => {};

  @override
  String url() {
    Uri uri;
    var pathStr = 'api/' + path() + pathParams;
    uri = Uri.https('iptv-org.github.io', pathStr, params);
    return uri.toString();
  }
  @override
  String path() {
    return "channels.json";
  }
}
