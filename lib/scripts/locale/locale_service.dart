import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService {
  static const String _key = 'app_locale';
  static final ValueNotifier<Locale?> localeNotifier =
      ValueNotifier<Locale?>(null);

  static Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null || code.isEmpty) {
      localeNotifier.value = null; // use system
      return;
    }
    switch (code) {
      case 'en':
        localeNotifier.value = const Locale('en');
        break;
      case 'zh_HK':
        localeNotifier.value = const Locale('zh', 'HK');
        break;
      default:
        localeNotifier.value = null;
    }
  }

  static Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_key);
      localeNotifier.value = null;
      return;
    }
    if (locale.languageCode == 'en') {
      await prefs.setString(_key, 'en');
    } else if (locale.languageCode == 'zh') {
      await prefs.setString(_key, 'zh_HK');
    }
    localeNotifier.value = locale;
  }
}
