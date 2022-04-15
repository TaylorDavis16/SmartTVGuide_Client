enum HttpMethod { get, post, delete }

///基础请求
abstract class BaseRequest {
  var pathParams = '';

  // static String authority = "www.dongdong16.com";
  static String authority = "192.168.1.10:8080";
  static String app = "SmartTVGuide/";

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = app + path() + pathParams;
    //拼接path参数
    uri = Uri.http(authority, pathStr, params);
    if (needLogin()) {
      //给需要登录的接口携带登录令牌
      // addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return uri.toString();
  }

  bool needLogin();

  ///参数列表
  Map<String, String> params = {};

  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {"auth-token": "lxd123"};

  ///添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
