import 'package:dio/dio.dart';

import '../request/base_request.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';

///Dio适配器
class DioAdapter<T> extends HiNetAdapter<T> {
  @override
  Future<HiNetResponse<T>> send(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    try {
      if (request.httpMethod() == HttpMethod.get) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.post) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.delete) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      response = e.response;
      throw HiNetError(response?.statusCode ?? -1, e.toString(),
          data: buildRes(response, request));
    }
    print("Leave Adapter");
    return buildRes(response, request);
  }

  ///构建HiNetResponse
  HiNetResponse<T> buildRes(Response response, BaseRequest request) {
    return HiNetResponse<T>(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
