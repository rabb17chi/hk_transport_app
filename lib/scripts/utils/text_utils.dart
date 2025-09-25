import 'settings_service.dart';

class TextUtils {
  // Removes trailing parenthetical stop codes like " (XX123)" when displayFull is false.
  static String cleanupStopDisplayName(String name, {bool? displayFull}) {
    final showFull =
        displayFull ?? SettingsService.displayBusFullNameNotifier.value;
    if (showFull) return name;
    final regex = RegExp("\\s*\\([A-Za-z]{2}\\d{3}\\)");
    return name.replaceAll(regex, "");
  }
}
