import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  // 单例模式
  static final SPUtils _instance = SPUtils._internal();
  factory SPUtils() => _instance;
  SPUtils._internal();

  late SharedPreferences _prefs;

  // 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 存储字符串
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  // 获取字符串
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // 存储整数
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  // 获取整数
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // 存储布尔值
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  // 获取布尔值
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // 存储双精度浮点数
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  // 获取双精度浮点数
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // 存储字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  // 获取字符串列表
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // 删除数据
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  // 清除所有数据
  Future<bool> clear() async {
    return _prefs.clear();
  }
}
