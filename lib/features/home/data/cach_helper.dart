import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
      
    }
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    if (_sharedPreferences == null) {
      print('SharedPreferences not initialized. Call init() first.');
      return false;
    }
    try {
      return await _sharedPreferences!.setBool(key, value);
    } catch (e) {
      print('Error saving boolean for key $key: $e');
      return false;
    }
  }

  static bool? getBoolean({required String key}) {
    if (_sharedPreferences == null) {
      print('SharedPreferences not initialized. Call init() first.');
      return null;
    }
    try {
      return _sharedPreferences!.getBool(key);
    } catch (e) {
      print('Error retrieving boolean for key $key: $e');
      return null;
    }
  }
}