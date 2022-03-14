import 'package:smart_tv_guide/http/request/base_request.dart';

class ImageFinder {
  static String base = 'http://' +
      BaseRequest.authority +
      '/' +
      BaseRequest.app +
      'resources/images/';
  static String defaultImg = 'offer.png';
}
