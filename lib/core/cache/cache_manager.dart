import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static final CacheManager _instance = CacheManager._init();

  factory CacheManager() {
    return _instance;
  }

  CacheManager._init();
  late final SharedPreferences prefs;

  static int albumLineType = 0;
  static int artistLineType = 0;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(PrefTagsString key, String value) async {
    await prefs.setString(key.name, value);
  }

  String getString(PrefTagsString key, String defaultValue) {
    String result = prefs.getString(key.name) ?? defaultValue;
    return result;
  }
}

enum PrefTagsString {
  recordSort,
  recordOrder,
}
