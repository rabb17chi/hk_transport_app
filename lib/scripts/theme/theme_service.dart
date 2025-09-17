import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Service
///
/// Manages app theme switching between light and dark modes
class ThemeService {
  static const String _themeKey = 'app_theme';
  static const String _lightTheme = 'light';
  static const String _darkTheme = 'dark';
  static const String _systemTheme = 'system';

  // Theme notifier for reactive updates
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  /// Initialize theme service
  static Future<void> initialize() async {
    final theme = await getStoredTheme();
    themeNotifier.value = theme;
  }

  /// Get stored theme preference
  static Future<ThemeMode> getStoredTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey) ?? _systemTheme;

      switch (themeString) {
        case _lightTheme:
          return ThemeMode.light;
        case _darkTheme:
          return ThemeMode.dark;
        case _systemTheme:
        default:
          return ThemeMode.system;
      }
    } catch (e) {
      return ThemeMode.system;
    }
  }

  /// Set theme preference
  static Future<void> setTheme(ThemeMode theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;

      switch (theme) {
        case ThemeMode.light:
          themeString = _lightTheme;
          break;
        case ThemeMode.dark:
          themeString = _darkTheme;
          break;
        case ThemeMode.system:
          themeString = _systemTheme;
          break;
      }

      await prefs.setString(_themeKey, themeString);
      themeNotifier.value = theme;
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Get dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
        primary: const Color(0xFFEBEBEB), // rgb(235,235,235) for selected items
        onPrimary: const Color(0xFF282828), // Dark background for contrast
        secondary: Colors.blue,
        onSecondary: const Color(0xFFEBEBEB),
        surface: const Color(0xFF3A3A3A),
        onSurface: const Color(0xFFEBEBEB),
      ),
      primaryColor: const Color(
          0xFF64B5F6), // Light blue for dark mode - lighter than default
      primaryColorDark:
          const Color(0xFF90CAF9), // Even lighter blue for dark mode
      scaffoldBackgroundColor: const Color(0xFF282828), // rgb(40,40,40)
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF282828),
        foregroundColor: Color(
            0xFF90CAF9), // Use lighter primary color for better visibility
      ),
      textTheme: const TextTheme(
        bodyLarge:
            TextStyle(color: Color(0xFFEBEBEB)), // rgb(235,235,235) - lighter
        bodyMedium: TextStyle(color: Color(0xFFEBEBEB)),
        bodySmall: TextStyle(color: Color(0xFFEBEBEB)),
        titleLarge: TextStyle(color: Color(0xFFEBEBEB)),
        titleMedium: TextStyle(color: Color(0xFFEBEBEB)),
        titleSmall: TextStyle(color: Color(0xFFEBEBEB)),
        headlineLarge: TextStyle(color: Color(0xFFEBEBEB)),
        headlineMedium: TextStyle(color: Color(0xFFEBEBEB)),
        headlineSmall: TextStyle(color: Color(0xFFEBEBEB)),
        displayLarge: TextStyle(color: Color(0xFFEBEBEB)),
        displayMedium: TextStyle(color: Color(0xFFEBEBEB)),
        displaySmall: TextStyle(color: Color(0xFFEBEBEB)),
        labelLarge: TextStyle(color: Color(0xFFEBEBEB)),
        labelMedium: TextStyle(color: Color(0xFFEBEBEB)),
        labelSmall: TextStyle(color: Color(0xFFEBEBEB)),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF3A3A3A),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Color(0xFFEBEBEB), // rgb(235,235,235) - lighter
        iconColor: Color(0xFFEBEBEB),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        textColor: Color(0xFFEBEBEB), // rgb(235,235,235) - lighter
        iconColor: Color(0xFFEBEBEB),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF505050), // rgb(80,80,80) - lighter grey
        selectedItemColor: Color(
            0xFF90CAF9), // Use lighter primary color for better visibility
        unselectedItemColor:
            Color(0xFF787878), // rgb(120,120,120) - darker grey
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF555555),
      ),
    );
  }

  /// Get current theme based on system preference
  static ThemeData getCurrentTheme(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? getDarkTheme() : getLightTheme();
  }
}
