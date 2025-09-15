import 'package:shared_preferences/shared_preferences.dart';
import 'locale_service.dart';

class StartupService {
  static Future<bool> loadInitialPlatformIsMTR() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString('last_platform');
    return (last == 'MTR') || last == null;
  }

  static Future<void> initializeApp() async {
    await LocaleService.loadSavedLocale();
  }
}
