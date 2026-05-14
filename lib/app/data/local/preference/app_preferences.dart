import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception('AppPreferences not initialized. Call AppPreferences.init() first.');
    }
    return _prefs!;
  }

  static Future<bool> setString(String key, String value) {
    return instance.setString(key, value);
  }

  static String? getString(String key) {
    return instance.getString(key);
  }

  static Future<bool> remove(String key) {
    return instance.remove(key);
  }

  static Future<bool> clear() {
    return instance.clear();
  }
}
