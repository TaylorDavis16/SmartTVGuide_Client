import 'package:dio/dio.dart';
import 'package:smart_tv_guide/util/app_util.dart';

import '../request/base_request.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';

///Dio适配器
class DioAdapter<T> extends HiNetAdapter<T> {
  @override
  Future<HiNetResponse<T>> send(BaseRequest request) async {
    Response? response;
    var options = Options(headers: request.header);
    try {
      switch (request.httpMethod()) {
        case HttpMethod.get:
          response = await Dio().get(request.url(), options: options);
          break;
        case HttpMethod.post:
          response = await Dio()
              .post(request.url(), data: request.params, options: options);
          break;
        case HttpMethod.delete:
          response = await Dio()
              .delete(request.url(), data: request.params, options: options);
          break;
      }
    } on DioError catch (e) {
      response = e.response;
      throw HiNetError(response?.statusCode ?? -1, e.toString(),
          data: buildRes(response, request));
    }
    logger.d("Leave Adapter");
    return buildRes(response, request);
  }

  ///构建HiNetResponse
  HiNetResponse<T> buildRes(Response? response, BaseRequest request) {
    return HiNetResponse<T>(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response);
  }
}
