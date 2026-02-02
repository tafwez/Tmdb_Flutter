import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  PrefsManager._internal();

  static final PrefsManager _instance = PrefsManager._internal();
  factory PrefsManager() => _instance;

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ================== STRING ==================
  static Future<bool> setString(String key, String value) async {
    return _prefs?.setString(key, value) ?? Future.value(false);
  }

  static String getString(String key, {String defaultValue = ''}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  // ================== BOOL ==================
  static Future<bool> setBool(String key, bool value) async {
    return _prefs?.setBool(key, value) ?? Future.value(false);
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  // ================== INT ==================
  static Future<bool> setInt(String key, int value) async {
    return _prefs?.setInt(key, value) ?? Future.value(false);
  }

  static int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  // ================== DOUBLE ==================
  static Future<bool> setDouble(String key, double value) async {
    return _prefs?.setDouble(key, value) ?? Future.value(false);
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs?.getDouble(key) ?? defaultValue;
  }

  // ================== LIST STRING ==================
  static Future<bool> setStringList(String key, List<String> value) async {
    return _prefs?.setStringList(key, value) ?? Future.value(false);
  }

  static List<String> getStringList(
      String key, {
        List<String> defaultValue = const [],
      }) {
    return _prefs?.getStringList(key) ?? defaultValue;
  }

  // ================== REMOVE / CLEAR ==================
  static Future<bool> remove(String key) async {
    return _prefs?.remove(key) ?? Future.value(false);
  }

  static Future<bool> clearAll() async {
    return _prefs?.clear() ?? Future.value(false);
  }

  static bool contains(String key) {
    return _prefs?.containsKey(key) ?? false;
  }
}
