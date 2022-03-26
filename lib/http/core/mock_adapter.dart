import '../request/base_request.dart';
import 'requester_adapter.dart';

///测试适配器，mock数据
class MockAdapter extends RequesterAdapter {
  @override
  Future<MyNetResponse<Map<dynamic, dynamic>>> send(BaseRequest request) {
    return Future<MyNetResponse<Map>>.delayed(
        const Duration(milliseconds: 1000), () {
      return MyNetResponse(
          data: {"code": 0, "message": 'success'}, statusCode: 401);
    });
  }
}
