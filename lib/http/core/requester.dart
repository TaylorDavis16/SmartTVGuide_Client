import 'package:dio/dio.dart';
import 'package:smart_tv_guide/http/core/dio_adapter.dart';
import 'package:smart_tv_guide/http/core/requester_adapter.dart';
import 'package:smart_tv_guide/http/request/base_request.dart';
import 'package:smart_tv_guide/util/app_util.dart';
import 'package:smart_tv_guide/util/view_util.dart';

import 'request_error.dart';
import 'hi_interceptor.dart';

class Requester {
  Requester._internal();

  late HiErrorInterceptor _hiErrorInterceptor;

  factory Requester() => _instance;

  static late final Requester _instance = Requester._internal();

  Future fire(BaseRequest request) async {
    MyNetResponse response;
    try {
      response = await send(request);
    } on RequestError catch (e) {
      response = e.data;
      if(response.extra == DioErrorType.other){
        showWarnToast('Network Error');
        return;
      }
    } catch (e) {
      logger.wtf('Something really bad happened!!!!!!!!!!!!!!!!');
      logger.w(e);
      return;
    }
    var result = response.data;
    var status = response.statusCode;
    RequestError hiError;
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
        hiError = RequestError(status ?? 0, result.toString(), data: result);
    }
    _hiErrorInterceptor(hiError);
    throw hiError;
  }

  Future<MyNetResponse<T>> send<T>(BaseRequest request) async {
    logger.i('url:${request.url()}');
    RequesterAdapter<T> adapter = DioAdapter<T>();
    return adapter.send(request);
  }

  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    _hiErrorInterceptor = interceptor;
  }


}
