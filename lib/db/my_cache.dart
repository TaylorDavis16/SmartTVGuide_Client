import 'package:shared_preferences/shared_preferences.dart';

///缓存管理类
class MyCache {
  factory MyCache() => _instance;

  MyCache._internal();

  static late SharedPreferences _prefs;

  static late final MyCache _instance = MyCache._internal();

  ///预初始化，防止在使用get时，prefs还未完成初始化
  static Future<void> preInit() async {
    _prefs = await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    _prefs.setString(key, value);
  }

  setDouble(String key, double value) {
    _prefs.setDouble(key, value);
  }

  setInt(String key, int value) {
    _prefs.setInt(key, value);
  }

  setBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    _prefs.setStringList(key, value);
  }

  Object? get(String key) {
    return _prefs.get(key);
  }
}
