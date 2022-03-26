import 'package:smart_tv_guide/model/hot_program_model.dart';

import '../http/core/request_error.dart';
import '../http/core/requester.dart';
import '../http/request/hot_request.dart';

class ProgramDao {
  static Future<HotProgramModel> hotData(int index, int pageIndex, int pageSize,
      {swiper = false}) async {
    HotRequest request = HotRequest();
    request
        .add('index', index)
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize)
        .add('swiper', swiper);
    var result = await Requester().fire(request);
    if (result['code'] != 1) {
      throw RequestError(result['code'], result['message']);
    }

    return HotProgramModel.fromJson(result['model']);
  }
}
