import 'package:smart_tv_guide/http/core/dio_adapter.dart';
import 'package:smart_tv_guide/http/core/hi_net_adapter.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';

import 'hi_error.dart';
import 'hi_interceptor.dart';

class HiNet {
  HiNet._internal();

  late HiErrorInterceptor _hiErrorInterceptor;
  factory HiNet() => _instance;

  static late final HiNet _instance = HiNet._internal();

  Future fire(BaseRequest request) async {
    HiNetResponse response;
    try {
      response = await send(request);
    } on HiNetError catch(e){
      response = e.data;
      printLog('----------------------------------------------------------');
      printLog(e.message);
    } catch(e){
      printLog('Something really bad happened!!!!!!!!!!!!!!!!');
      printLog(e);
      return;
    }
    printLog(response.request);
    // printLog(response.extra);
    // printLog(response.statusMessage);
    var result = response.data;
    printLog('code: ${result['code']}');
    var status = response.statusCode;
    printLog(status);
    printLog('----------------------------------------------------------');
    var hiError;
    switch (status) {
      case 200:
        return result;
      case 401:
        hiError = NeedLogin();
        break;
      case 403:
      case 407:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      case 404:
        hiError = PageNotFound(result.toString(), data: result);
        break;
      case 500:
        hiError = ServerError(result.toString(), data: result);
        break;
      default:
        hiError = HiNetError(status ?? 0, result.toString(), data: result);
    }
    if (_hiErrorInterceptor != null) {
      _hiErrorInterceptor(hiError);
    }
    throw hiError;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    _hiErrorInterceptor = interceptor;
  }

  printLog(Object? object) {
    print('HiNet: $object');
  }
}
