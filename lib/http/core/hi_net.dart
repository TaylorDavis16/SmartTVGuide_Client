import 'package:smart_tv_guide/http/core/dio_adapter.dart';
import 'package:smart_tv_guide/http/core/hi_net_adapter.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';
import 'package:smart_tv_guide/util/app_util.dart';

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
    } on HiNetError catch (e) {
      response = e.data;
      logger.w('----------------------------------------------------------');
      logger.w(e.message);
    } catch (e) {
      logger.wtf('Something really bad happened!!!!!!!!!!!!!!!!');
      logger.w(e);
      return;
    }
    // logger.i(e);(response.extra);
    // logger.i(e);(response.statusMessage);
    var result = response.data;
    logger.d('code: ${result['code']}');
    var status = response.statusCode;
    logger.d(status);
    HiNetError hiError;
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
    _hiErrorInterceptor(hiError);
    throw hiError;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    logger.i('url:${request.url()}');
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    _hiErrorInterceptor = interceptor;
  }


}
