import 'dart:convert';

import '../request/base_request.dart';

///网络请求抽象类
abstract class RequesterAdapter<T> {
  Future<MyNetResponse<T>> send(BaseRequest request);
}

/// 统一网络层返回格式
class MyNetResponse<T> {
  MyNetResponse({
    this.data,
    this.request,
    this.statusCode,
    this.statusMessage,
    this.extra,
  });

  /// Response body. may have been transformed, please refer to [ResponseType].
  T? data;

  /// The corresponding request info.
  BaseRequest? request;

  /// Http status code.
  int? statusCode;

  /// Returns the reason phrase associated with the status code.
  /// The reason phrase must be set before the body is written
  /// to. Setting the reason phrase after writing to the body.
  String? statusMessage;

  /// Custom field that you can retrieve it later in `then`.
  dynamic extra;

  /// We are more concerned about `data` field.
  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
