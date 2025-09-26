import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeService {
  static const String _key = 'first_time_completed_v1';

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_key) ?? false;
    return !completed;
  }

  static Future<void> setCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
