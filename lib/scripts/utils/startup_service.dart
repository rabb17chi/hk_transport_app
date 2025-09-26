import 'package:shared_preferences/shared_preferences.dart';
import '../locale/locale_service.dart';

class StartupService {
  static Future<bool> loadInitialPlatformIsMTR() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString('last_platform');
    // Default to KMB when not set (isMTR = false). Only return true if explicitly saved as 'MTR'.
    return last == 'MTR';
  }

  static Future<void> initializeApp() async {
    await LocaleService.loadSavedLocale();
  }
}
