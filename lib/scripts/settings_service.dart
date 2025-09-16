import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _mtrReverseKey = 'mtr_reverse_stations_v1';

  static final ValueNotifier<bool> mtrReverseStationsNotifier =
      ValueNotifier<bool>(false);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_mtrReverseKey) ?? false;
    mtrReverseStationsNotifier.value = value;
  }

  static Future<void> setMtrReverseStations(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mtrReverseKey, value);
    mtrReverseStationsNotifier.value = value;
  }
}
