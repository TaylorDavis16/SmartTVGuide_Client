
import '../request/base_request.dart';
import 'hi_net_adapter.dart';

///测试适配器，mock数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<Map<dynamic, dynamic>>> send(BaseRequest request) {
    return Future<HiNetResponse<Map>>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          data: {"code":0, "message": 'success'}, statusCode: 401);
    });
  }
}
