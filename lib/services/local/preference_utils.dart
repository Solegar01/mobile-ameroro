import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static PreferenceUtils? _instance;
  static SharedPreferences? _preferences;

  // call this method from iniState() function of mainApp().
  static Future<PreferenceUtils?> init() async {
    _instance ??= PreferenceUtils();
    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  static dynamic getFromDisk(String key) {
    try {
      var x = _preferences?.get(key);
      return _preferences?.get(key);
    } catch (err) {
      rethrow;
    }
  }

  static void saveToDisk(String key, dynamic content) {
    try {
      if (content is String) {
        _preferences?.setString(key, content);
      } else if (content is int) {
        _preferences?.setInt(key, content);
      } else if (content is bool) {
        _preferences?.setBool(key, content);
      } else if (content is double) {
        _preferences?.setDouble(key, content);
      } else if (content is List<String>) {
        _preferences?.setStringList(key, content);
      } else {
        throw '${content.runtimeType} is not valid for shared preferences';
      }
    } catch (err) {
      rethrow;
    }
  }

  static void clearDisk() {
    try {
      _preferences?.clear();
    } catch (err) {
      rethrow;
    }
  }

  static bool containKey(String key) {
    try {
      bool? value = _preferences?.containsKey(key);
      return value ?? false;
    } catch (err) {
      rethrow;
    }
  }

  static void removeKey(String key) {
    try {
      _preferences?.remove(key);
    } catch (err) {
      rethrow;
    }
  }
}
